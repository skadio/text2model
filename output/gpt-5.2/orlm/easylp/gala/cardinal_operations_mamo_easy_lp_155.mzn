include "globals.mzn";

% Data (embedded as required)
int: costX = 300000;
int: costY = 200000;
int: maxTotal = 10;

% Decision variables: number of properties of each type (whole units)
var 1..maxTotal: x;  % type X
var 1..maxTotal: y;  % type Y

% Constraints
constraint x + y <= maxTotal;      % zoning limit
constraint x >= 5 * y;             % balance requirement (X at least five times Y)

% Objective: minimize total investment
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = ", show(totalCost), "\n"
];