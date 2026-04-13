include "globals.mzn";

% Data (embedded from the problem description)
int: minX = 10;
int: minY = 5;
int: maxTotal = 40;

int: costX = 50;
int: costY = 80;

% Decision variables: whole-number hours allocated to each team
var minX..maxTotal: hoursX;
var minY..maxTotal: hoursY;

% Constraints
constraint hoursX + hoursY <= maxTotal;

% Objective: minimize total cost
var int: totalCost = costX * hoursX + costY * hoursY;

solve minimize totalCost;

output [
  "hoursX = ", show(hoursX), "\n",
  "hoursY = ", show(hoursY), "\n",
  "minimum_total_cost = ", show(totalCost), "\n"
];