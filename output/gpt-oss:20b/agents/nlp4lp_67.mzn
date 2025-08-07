include "globals.mzn";

/* ---------- Data ---------- */
int: M;                       % number of width types
int: N;                       % number of cutting patterns
int: large_roll_width;        % width of a large roll (unused in model)

array[1..M] of int: demands;          % demand for each width type
array[1..M] of int: roll_width_options;  % width options (unused here)

array[1..N, 1..M] of int: patterns;   % pattern[i,j] = # of rolls of width j in pattern i

/* ---------- Variables ---------- */
array[1..N] of var 0..maxInt: x;       % number of times each pattern is used

/* ---------- Constraints ---------- */
% Meet or exceed the demand for every width type
constraint
  forall(j in 1..M) (
    sum(i in 1..N)(patterns[i,j] * x[i]) >= demands[j]
  );

/* ---------- Objective ---------- */
solve minimize sum(x);

/* ---------- Output ---------- */
output [
  "Minimum number of large rolls needed: ", show(sum(x)), "\n",
  "Pattern usage: ", show(x), "\n"
];