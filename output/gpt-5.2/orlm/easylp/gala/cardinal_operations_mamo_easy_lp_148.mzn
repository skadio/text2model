include "globals.mzn";

% Data (embedded from problem statement)
int: demand = 50;          % need at least 50 units transported
int: capX = 1;             % 1 unit per ship X
int: capY = 1;             % 1 unit per ship Y
int: opLimit = 120;        % operational limit on (2X + 1Y)
int: costX = 7;
int: costY = 5;

% Decision variables (whole numbers)
var 0..demand: x;          % number of type X ships
var 0..demand: y;          % number of type Y ships

% Constraints
constraint capX * x + capY * y >= demand;      % meet demand
constraint 2 * x + 1 * y <= opLimit;           % operational constraint

% Objective: minimize total operating cost
var int: totalCost = costX * x + costY * y;
solve minimize totalCost;

output [
  "x (ships X) = ", show(x), "\n",
  "y (ships Y) = ", show(y), "\n",
  "Minimum total cost (rounded) = ", show(totalCost), "\n"
];