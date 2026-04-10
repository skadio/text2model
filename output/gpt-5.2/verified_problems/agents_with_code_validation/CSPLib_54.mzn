include "globals.mzn";

% Parameters
int: n;                           % Size of the chessboard (N) and number of queens
set of int: ROWS = 1..n;          % Row indices
set of int: COLS = 1..n;          % Column indices

array[ROWS] of int: queens;       % Optional input: queens[r] = fixed column for row r (use 0 if not fixed)

% Variables
array[ROWS] of var COLS: q_col;   % Decision variables: q_col[r] = column of the queen in row r

% Constraints

% Link provided input positions (if any) to decision variables
constraint
  forall(r in ROWS) (
    (queens[r] >= min(COLS) /\ queens[r] <= max(COLS)) -> (q_col[r] = queens[r])
  );

% No two queens may share the same column
constraint all_different(q_col);

% Diagonals must be all different
constraint all_different([ r - q_col[r] | r in ROWS ]);
constraint all_different([ r + q_col[r] | r in ROWS ]);

solve satisfy;