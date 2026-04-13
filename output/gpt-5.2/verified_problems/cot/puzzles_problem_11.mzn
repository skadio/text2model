% Parameters
int: n;
array[1..n] of int: b;          % number of bottles of each type
array[1..n] of int: t;          % fill amount per bottle type, scaled to integers
int: num_people;

% Variables
array[1..n, 1..num_people] of var 0..max(b): x;  % x[i,p] bottles of type i given to person p

% Constraints
% Basic feasibility / bounds
constraint forall(i in 1..n, p in 1..num_people) (x[i,p] >= 0 /\ x[i,p] <= b[i]);

% Use all bottles of each type
constraint forall(i in 1..n) (
  sum(p in 1..num_people)(x[i,p]) = b[i]
);

% Each person gets the same number of bottles
constraint forall(p in 1..num_people) (
  sum(i in 1..n)(x[i,p]) = sum(i in 1..n)(b[i]) div num_people
);
constraint sum(i in 1..n)(b[i]) mod num_people = 0;

% Each person gets the same amount of liquid (scaled by t)
constraint forall(p in 1..num_people) (
  sum(i in 1..n)(t[i] * x[i,p]) = sum(i in 1..n)(t[i] * b[i]) div num_people
);
constraint sum(i in 1..n)(t[i] * b[i]) mod num_people = 0;

% Lexicographical order of allocations (person 1 <=lex person 2 <=lex ...).
% Compare vectors (x[1..n,p]) lexicographically.
constraint forall(p in 1..num_people-1) (
  lex_lesseq([x[i,p] | i in 1..n], [x[i,p+1] | i in 1..n])
);

% Objective
solve satisfy;