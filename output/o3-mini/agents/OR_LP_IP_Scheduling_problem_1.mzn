include "globals.mzn";

% Data declarations (to be provided in the .dzn file)
int: num_skis;
int: num_skiers;
array[1..num_skis] of int: ski_heights;
array[1..num_skiers] of int: skier_heights;

% Decision variable: assign a unique ski to each skier
array[1..num_skiers] of var 1..num_skis: ski_assignment;
constraint all_different(ski_assignment);

% Calculate the total disparity as the sum of absolute differences 
% between skier heights and the heights of the skis assigned to them.
var int: total_disparity = sum(i in 1..num_skiers)(
    abs( skier_heights[i] - ski_heights[ski_assignment[i]] )
);

% Solve: minimize the total disparity
solve minimize total_disparity;

% Output the assignment and the total disparity
output [
    "Ski Assignment: ", show(ski_assignment), "\n",
    "Total Disparity: ", show(total_disparity), "\n"
];