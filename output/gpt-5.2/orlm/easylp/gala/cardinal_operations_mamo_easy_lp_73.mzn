% Crop planning cost minimization (all data embedded)

% Decision variables: whole acres
var 0..50: x;  % acres of crop X
var 0..50: y;  % acres of crop Y

% Parameters
int: costX = 100;
int: costY = 200;

% Constraints
constraint 2*x + 3*y <= 50;
constraint x >= y + 10;

% Objective
var int: total_cost = costX * x + costY * y;
solve minimize total_cost;

output [
  "x_acres = ", show(x), "\n",
  "y_acres = ", show(y), "\n",
  "min_total_cost = $", show(total_cost), "\n"
];