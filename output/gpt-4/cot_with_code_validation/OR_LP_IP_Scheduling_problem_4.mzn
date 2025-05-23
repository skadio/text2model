% Parameters
int: n; % Size of the grid
array[1..n, 1..n] of 0..1: huts; % Grid representing the location of villagers

% Variables
var 1..n: drop1_x; % X-coordinate of the first drop location
var 1..n: drop1_y; % Y-coordinate of the first drop location
var 1..n: drop2_x; % X-coordinate of the second drop location
var 1..n: drop2_y; % Y-coordinate of the second drop location

% Constraints
% No constraints as the drop locations can be anywhere on the grid

% Objective
% Minimize the sum of squared distances of huts to their closest relief package destination
solve minimize sum(i in 1..n, j in 1..n) (
    huts[i,j] * min(
        (i-drop1_x)^2 + (j-drop1_y)^2, 
        (i-drop2_x)^2 + (j-drop2_y)^2
    )
);