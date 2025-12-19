% Parameters
int: n; % Size of the grid - number of rows and columns
array[1..n, 1..n] of int: huts; % Grid representing the location of villagers in need of relief supplies

% Variables
var 1..n: drop1_row; % Row coordinate of the first airdrop location
var 1..n: drop1_col; % Column coordinate of the first airdrop location
var 1..n: drop2_row; % Row coordinate of the second airdrop location
var 1..n: drop2_col; % Column coordinate of the second airdrop location

% Constraints

% Constraint to ensure that the two airdrop locations are not the same
constraint drop1_row != drop2_row \/ drop1_col != drop2_col;

% Objective
solve minimize sum(i in 1..n, j in 1..n) (
    huts[i,j] * min(
        (i-drop1_row)^2 + (j-drop1_col)^2,
        (i-drop2_row)^2 + (j-drop2_col)^2
    )
);