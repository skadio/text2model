include "globals.mzn";

int: r;                                    % Number of rows
int: c;                                    % Number of columns
array[1..r, 1..c] of int: puzzle;          % 0 = empty cell, >0 = pre-filled number

int: N = r * c;                            % Total amount of numbers/cells

% For every number 1..N keep its row and column
array[1..N] of var 1..r: row_of;
array[1..N] of var 1..c: col_of;

% A one–dimensional position code to guarantee uniqueness of cells
array[1..N] of var 1..N: pos;
constraint
    forall(k in 1..N)(
        pos[k] = (row_of[k] - 1) * c + col_of[k]
    );

% No two numbers occupy the same cell
constraint alldifferent(pos);

% Respect the given clues
constraint
    forall(i in 1..r, j in 1..c where puzzle[i,j] > 0)(
        row_of[puzzle[i,j]] = i /\
        col_of[puzzle[i,j]] = j
    );

% Consecutive numbers must be neighbours (8-neighbourhood)
constraint
    forall(k in 1..N-1)(
        abs(row_of[k] - row_of[k+1]) <= 1 /\
        abs(col_of[k] - col_of[k+1]) <= 1 /\
        (row_of[k] != row_of[k+1] \/ col_of[k] != col_of[k+1])
    );

solve satisfy;