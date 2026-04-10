include "globals.mzn";

%========================
% Input data (.dzn)
%========================
int: n;                          % number of bottle types
array[1..n] of int: b;           % number of bottles of each type
array[1..n] of int: t;           % fill amount units per bottle type (e.g., [2,1,0] for [1,1/2,0] scaled by 2)
int: num_people;                 % number of people

%========================
% Decision variables
%========================
% allocation[p,i] = number of bottles of type i given to person p
array[1..num_people, 1..n] of var 0..max(b): allocation;

%========================
% Feasibility checks
%========================
int: total_bottles = sum(i in 1..n)(b[i]);
int: total_liquid  = sum(i in 1..n)(b[i] * t[i]);

constraint total_bottles mod num_people = 0;
constraint total_liquid  mod num_people = 0;

int: bottles_per_person = total_bottles div num_people;
int: liquid_per_person  = total_liquid  div num_people;

%========================
% Constraints
%========================
% Use all bottles of each type
constraint forall(i in 1..n)(
  sum(p in 1..num_people)(allocation[p,i]) = b[i]
);

% Each person gets the same number of bottles
constraint forall(p in 1..num_people)(
  sum(i in 1..n)(allocation[p,i]) = bottles_per_person
);

% Each person gets the same amount of liquid
constraint forall(p in 1..num_people)(
  sum(i in 1..n)(allocation[p,i] * t[i]) = liquid_per_person
);

% Lexicographical order of allocations across people (symmetry breaking)
constraint forall(p in 1..num_people-1)(
  lex_lesseq([allocation[p,i] | i in 1..n],
             [allocation[p+1,i] | i in 1..n])
);

%========================
% Objective
%========================
solve satisfy;

output [
  "bottles_per_person=", show(bottles_per_person), "\n",
  "liquid_per_person=", show(liquid_per_person), "\n",
  "allocation (rows=people, cols=types):\n",
  concat([ concat([ show(allocation[p,i]) ++ (if i<n then " " else "" endif)
                    | i in 1..n ]) ++ "\n"
          | p in 1..num_people ])
];