include "globals.mzn";

% Data (embedded from problem statement)
int: costX = 200000;
int: costY = 300000;
int: maxProps = 10;

% Decision variables: number of properties at each location
var 1..maxProps: x;   % at least one at X
var 1..maxProps: y;   % at least one at Y

% Constraints
constraint x + y <= maxProps;
constraint x >= 3 * y;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = ", show(totalCost), "\n"
];