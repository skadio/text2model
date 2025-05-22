% Parameters
int: r;
int: c;
float: Z;
float: M;

set of int: ROWS = 1..r;
set of int: COLS = 1..c;
set of int: INNER_ROWS = { i | i in ROWS where i > 1 /\ i < r };
set of int: INNER_COLS = { j | j in COLS where j > 1 /\ j < c };

% Variables
array[ROWS, COLS] of var Z..M: V;

% Constraints
constraint
  forall(i in INNER_ROWS, j in INNER_COLS) (
    4.0 * V[i,j] = V[i-1,j] + V[i+1,j] + V[i,j-1] + V[i,j+1]
  );

% Objective
solve minimize V[1,1];