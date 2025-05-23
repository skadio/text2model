% Parameters
int: n;
array[1..n, 1..n] of int: huts;

% Variables
var 1..n: row1;
var 1..n: col1;
var 1..n: row2;
var 1..n: col2;

% Constraints
constraint
    row1 != row2 \/ col1 != col2;

% Objective
var int: total_distance =
    sum(i in 1..n, j in 1..n)(
        huts[i,j] *
        min(
            (i - row1)*(i - row1) + (j - col1)*(j - col1),
            (i - row2)*(i - row2) + (j - col2)*(j - col2)
        )
    );

solve minimize total_distance;