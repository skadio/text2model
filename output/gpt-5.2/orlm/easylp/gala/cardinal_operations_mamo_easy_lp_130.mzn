include "globals.mzn";

% Data (embedded from the problem statement)
int: max_cap = 5000;
int: min_diff = 100;

% Costs per activity: 0.5 for X and 0.3 for Y
% Use scaling by 10 to keep everything integer: 0.5 -> 5, 0.3 -> 3
int: scale = 10;
int: costX = 5;
int: costY = 3;

% Decision variables: integer number of activities
var 0..max_cap: x;   % activities for Project X
var 0..max_cap: y;   % activities for Project Y

% Constraints
constraint 2 * x + 3 * y <= max_cap;
constraint abs(x - y) >= min_diff;

% Objective: minimize total cost (scaled by 10)
var 0..(costX*max_cap + costY*max_cap): totalCostScaled;
constraint totalCostScaled = costX * x + costY * y;

solve minimize totalCostScaled;

% Rounded to nearest integer (original units):
% totalCost = totalCostScaled / 10
% rounded = floor(totalCost + 0.5) = floor((totalCostScaled + 5) / 10)
var int: totalCostRounded = (totalCostScaled + scale div 2) div scale;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCostScaled(=10x cost) = ", show(totalCostScaled), "\n",
  "totalCostRounded = ", show(totalCostRounded), "\n"
];