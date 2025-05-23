include "globals.mzn";

% Parameters
int: r;
int: c;
array[1..r, 1..c] of int: puzzle;
int: N = r * c;

% Variables
array[1..r, 1..c] of var 1..N: grid;
array[1..N] of var 1..r: row_of;
array[1..N] of var 1..c: col_of;

% Constraints

% Respect pre-filled values
constraint
  forall(i in 1..r, j in 1..c where puzzle[i,j] > 0) (
    grid[i,j] = puzzle[i,j]
  );

% Each number 1..N appears exactly once
constraint
  all_different([grid[i,j] | i in 1..r, j in 1..c]);

% Channel numbers to their coordinates
constraint
  forall(n in 1..N) (
    grid[row_of[n], col_of[n]] = n
  );

% Consecutive numbers are king-move adjacent
constraint
  forall(n in 1..N-1) (
    abs(row_of[n] - row_of[n+1]) <= 1 /\
    abs(col_of[n] - col_of[n+1]) <= 1
  );

% Objective
solve satisfy;