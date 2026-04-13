% Parameters
int: n;                         % number of bottle types
array[1..n] of int: b;          % number of bottles of each type
array[1..n] of int: t;          % fill amount per bottle type, scaled to integers (e.g., [1,1/2,0] -> [2,1,0])
int: num_people;                % number of people

% Variables
array[1..num_people, 1..n] of var 0..max(b): x;  % x[p,i] = number of bottles of type i given to person p

var 0..sum(i in 1..n)(b[i]): bottles_per_person;
var 0..sum(i in 1..n)(b[i]*t[i]): liquid_per_person;

% Constraints
constraint bottles_per_person * num_people = sum(i in 1..n)(b[i]);
constraint liquid_per_person * num_people = sum(i in 1..n)(b[i] * t[i]);

constraint forall(p in 1..num_people)(
  sum(i in 1..n)(x[p,i]) = bottles_per_person
);

constraint forall(p in 1..num_people)(
  sum(i in 1..n)(x[p,i] * t[i]) = liquid_per_person
);

constraint forall(i in 1..n)(
  sum(p in 1..num_people)(x[p,i]) = b[i]
);

% Lexicographical order of allocations across people (nondecreasing rows)
constraint forall(p in 1..num_people-1)(
  lex_lesseq([x[p,i] | i in 1..n], [x[p+1,i] | i in 1..n])
);

% Objective
solve satisfy;