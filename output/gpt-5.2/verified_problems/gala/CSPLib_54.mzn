include "globals.mzn";

int: n;

% queens[c] = row position of the queen in column c
array[1..n] of var 1..n: queens;

% No two queens share a row
constraint all_different(queens);

% No two queens share a diagonal
constraint all_different([queens[i] + i | i in 1..n]);
constraint all_different([queens[i] - i | i in 1..n]);

solve satisfy;

output [
  "n = ", show(n), "\n",
  "queens = ", show(queens), "\n"
];