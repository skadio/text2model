% Parameters
int: n;                              % Size of the chessboard (n x n) and number of queens
set of int: Q = 1..n;                % Index set for queens (and rows)

% Note: This array is included because it may be provided in the .dzn,
% but it is not needed for solving the standard N-Queens satisfaction model.
array[Q] of int: queens;             % Placeholder input, shape [n]

% Variables
array[Q] of var 1..n: col_of_queen;  % Decision: col_of_queen[r] = column position of the queen in row r

% Constraints
% One queen per row is implicit by representation (exactly one column per row).

% No two queens share the same column
constraint
  all_different(col_of_queen);

% No two queens share the same main diagonal (r - c constant)
constraint
  all_different([ r - col_of_queen[r] | r in Q ]);

% No two queens share the same anti-diagonal (r + c constant)
constraint
  all_different([ r + col_of_queen[r] | r in Q ]);

% Objective
solve satisfy;