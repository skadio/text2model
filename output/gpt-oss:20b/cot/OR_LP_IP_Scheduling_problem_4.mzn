% Parameters
int: n;
array[1..n, 1..n] of int: huts;

% Variables
var 1..n: drop1_row;
var 1..n: drop1_col;
var 1..n: drop2_row;
var 1..n: drop2_col;

% Constraints
constraint drop1_row != drop2_row \/ drop1_col != drop2_col;

% Objective
var int: total_distance;
constraint total_distance = sum(i in 1..n, j in 1..n) (
    huts[i,j] * min(
        (i - drop1_row)*(i - drop1_row) + (j - drop1_col)*(j - drop1_col),
        (i - drop2_row)*(i - drop2_row) + (j - drop2_col)*(j - drop2_col)
    )
);
solve minimize total_distance;