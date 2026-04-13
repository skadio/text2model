int: num_skis;                          % Number of available skis
int: num_skiers;                        % Number of skiers
array[1..num_skis] of int: ski_heights; % Array of ski heights
array[1..num_skiers] of int: skier_heights; % Array of skier heights

% Decision variable: assignment of skis to skiers
array[1..num_skiers] of var 1..num_skis: assigned_skis;

% Objective: minimize the total disparity
var int: total_disparity = sum(i in 1..num_skiers)(abs(ski_heights[assigned_skis[i]] - skier_heights[i]));

% Solve the optimization problem
solve minimize total_disparity;

% Output the results
output [
    "Total Disparity = ", show(total_disparity), "\n",
    "Assigned Skis = ", show([assigned_skis[i] | i in 1..num_skiers]), "\n"
];