include "globals.mzn";

/* ------------------ Input ------------------ */
int: n;                      % number of bottle types
array[1..n] of int: b;      % number of bottles of each type
array[1..n] of int: t;      % fill amount of each type
int: num_people;            % number of people

/* ------------------ Derived values ------------- */
int: total_bottles = sum(i in 1..n) b[i];
int: total_liquid  = sum(i in 1..n) t[i] * b[i];

constraint total_bottles mod num_people = 0;
constraint total_liquid  mod num_people = 0;

int: bottles_per_person = total_bottles div num_people;
int: liquid_per_person  = total_liquid  div num_people;

/* ------------------ Variables ------------------ */
array[1..num_people, 1..n] of var 0..b[i] : alloc;

/* ------------------ Constraints ---------------- */
constraint forall(i in 1..n) (
  sum(p in 1..num_people) alloc[p,i] = b[i]          % use all bottles
);

constraint forall(p in 1..num_people) (
  sum(i in 1..n) alloc[p,i]      = bottles_per_person /\  % same number of bottles
  sum(i in 1..n) t[i] * alloc[p,i] = liquid_per_person     % same liquid amount
);

/* Lexicographic ordering of rows */
constraint forall(p in 1..num_people-1) (
  lex_lesseq([alloc[p,j] | j in 1..n],
             [alloc[p+1,j] | j in 1..n])
);

/* ------------------ Solve --------------------- */
solve satisfy;

/* ------------------ Output -------------------- */
output [
  "Allocation matrix:\n",
  concat([ show([alloc[p,j] | j in 1..n]) ++ "\n" | p in 1..num_people ])
];