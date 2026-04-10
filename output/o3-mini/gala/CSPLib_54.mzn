include "globals.mzn";

int: n;  % Board size (and number of queens)

// queens[i] represents the row position of the queen in column i
array[1..n] of var 1..n: queens;

% Ensure that no two queens share the same row
constraint all_different(queens);

% Ensure that no two queens are on the same diagonal
constraint all_different([queens[i] + i | i in 1..n]);
constraint all_different([queens[i] - i | i in 1..n]);

solve satisfy;

output [ "Queens positions (rows by column): ", show(queens) ];