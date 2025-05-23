include "globals.mzn";

% Parameters
int: n; % Size of the grid
array[1..n, 1..n] of 0..1: huts; % Grid representing the location of villagers

% Variables
var 1..n: drop1_x; % X coordinate of the first drop location
var 1..n: drop1_y; % Y coordinate of the first drop location
var 1..n: drop2_x; % X coordinate of the second drop location
var 1..n: drop2_y; % Y coordinate of the second drop location

% Objective
var int: total_distance;
constraint total_distance = sum(i in 1..n, j in 1..n) (
    huts[i,j] * min(
        (i-drop1_x)^2 + (j-drop1_y)^2,
        (i-drop2_x)^2 + (j-drop2_y)^2
    )
);
minimize total_distance;

% Solve
solve minimize total_distance;

% Output
output ["Drop1: ", show(drop1_x), ",", show(drop1_y), "\n",
        "Drop2: ", show(drop2_x), ",", show(drop2_y), "\n",
        "Total distance: ", show(total_distance)];