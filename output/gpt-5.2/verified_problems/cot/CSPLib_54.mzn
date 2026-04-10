% Parameters
int: n;

% Variables
array[1..n] of var 1..n: queens;

% Constraints
constraint
  all_different(queens);

constraint
  all_different([queens[i] + i | i in 1..n]);

constraint
  all_different([queens[i] - i | i in 1..n]);

% Objective
solve satisfy;