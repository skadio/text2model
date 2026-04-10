include "globals.mzn";

%----------------------------
% Input data
%----------------------------
int: n;                              % number of bottle types
array[1..n] of int: b;               % number of bottles of each type
array[1..n] of int: t;               % "fill units" per type (e.g., [2,1,0] for [1,1/2,0])
int: num_people;

%----------------------------
% Derived constants & checks
%----------------------------
int: total_bottles = sum(i in 1..n)(b[i]);
int: total_units   = sum(i in 1..n)(b[i] * t[i]);

constraint total_bottles mod num_people = 0;
constraint total_units   mod num_people = 0;

int: bottles_per_person = total_bottles div num_people;
int: units_per_person   = total_units div num_people;

%----------------------------
% Decision variables
% alloc[p,k] = bottle type (1..n) assigned as the k-th bottle to person p
%----------------------------
array[1..num_people, 1..bottles_per_person] of var 1..n: alloc;

% Count how many bottles of each type each person gets
array[1..num_people, 1..n] of var 0..bottles_per_person: cnt;

constraint forall(p in 1..num_people, i in 1..n)(
  count([alloc[p,k] | k in 1..bottles_per_person], i, cnt[p,i])
);

% Use all bottles of each type exactly
constraint forall(i in 1..n)(
  sum(p in 1..num_people)(cnt[p,i]) = b[i]
);

% Equal liquid per person (in "units" given by t)
constraint forall(p in 1..num_people)(
  sum(i in 1..n)(cnt[p,i] * t[i]) = units_per_person
);

%----------------------------
% Symmetry breaking / ordering
%----------------------------
% Within each person: keep their multiset of types sorted
constraint forall(p in 1..num_people)(
  increasing([alloc[p,k] | k in 1..bottles_per_person])
);

% Across people: allocations in lexicographical nondecreasing order
constraint forall(p in 1..num_people-1)(
  lex_lesseq([alloc[p,k] | k in 1..bottles_per_person],
             [alloc[p+1,k] | k in 1..bottles_per_person])
);

solve satisfy;

output [
  "bottles_per_person = ", show(bottles_per_person), "\n",
  "units_per_person   = ", show(units_per_person), "\n",
  "alloc =\n",
  concat([ concat([ show(alloc[p,k]) ++ if k=bottles_per_person then "" else " " endif
                   | k in 1..bottles_per_person ]) ++ "\n"
          | p in 1..num_people ])
];