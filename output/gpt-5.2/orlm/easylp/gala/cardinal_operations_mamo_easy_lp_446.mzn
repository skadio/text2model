include "globals.mzn";

% Data (embedded as required)
int: costX = 20;
int: costY = 30;

int: x_lb = 0;
int: x_ub = 1000;
int: y_lb = 0;
int: y_ub = 500;

% Decision variables (whole-number allocations)
var x_lb..x_ub: x;   % resources for Project X
var y_lb..y_ub: y;   % resources for Project Y

% Constraints
constraint 5*x + 3*y >= 60;
constraint 4*x + y <= 80;
constraint x - y >= 10;

% Objective: minimize total cost
var int: total_cost = costX*x + costY*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];