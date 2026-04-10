include "globals.mzn";

% Data (embedded as required)
int: totalHoursMax = 40;
int: minEffort = 20;              % 2*X + Y >= 20
int: maxDiff = 10;                % |X - Y| <= 10
int: costX = 8;
int: costY = 10;
int: maxX = 25;
int: maxY = 15;

% Decision variables (whole hours)
var 0..maxX: x;   % hours for Task X
var 0..maxY: y;   % hours for Task Y

% Constraints
constraint x + y <= totalHoursMax;
constraint 2*x + y >= minEffort;
constraint abs(x - y) <= maxDiff;

% Objective
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_total_cost = ", show(totalCost), "\n"
];