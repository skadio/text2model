% Parameters
int: r;
int: c;
array[1..r, 1..c] of int: puzzle;

% ----- Derived constants
int: N_MIN = min([ puzzle[i,j] | i in 1..r, j in 1..c where puzzle[i,j] > 0 ]);
int: N_MAX = max([ puzzle[i,j] | i in 1..r, j in 1..c ]);
set of int: NUMBERS = N_MIN .. N_MAX;

% Variables
array[NUMBERS] of var 1..r: row_of;
array[NUMBERS] of var 1..c: col_of;
array[1..r, 1..c] of var NUMBERS: grid;

% Constraints
% 1. Each number occupies exactly one distinct cell
constraint
    all_different( [ (row_of[k] - 1) * c + col_of[k] | k in NUMBERS] );

% 2. Channel numbers to the grid
constraint
    forall(k in NUMBERS) (
        grid[row_of[k], col_of[k]] = k
    );

% 3. Respect pre-filled numbers
constraint
    forall(i in 1..r, j in 1..c where puzzle[i,j] > 0) (
        row_of[puzzle[i,j]] = i /\
        col_of[puzzle[i,j]] = j
    );

% 4. Ensure every cell is used (grid is fully covered)
constraint
    forall(i in 1..r, j in 1..c) (
        exists(k in NUMBERS)(row_of[k] = i /\ col_of[k] = j)
    );

% 5. Consecutive numbers must be in neighbouring cells (8-neighbourhood)
constraint
    forall(k in N_MIN .. N_MAX - 1) (
        abs(row_of[k] - row_of[k+1]) <= 1 /\
        abs(col_of[k] - col_of[k+1]) <= 1
    );

% Objective
solve satisfy;