% Training time allocation for two exercises X and Y (integer hours)
% Minimize total cost subject to time and facility constraints.

int: min_total_time = 15;
int: max_facility = 40;

int: cost_x = 20;
int: cost_y = 30;

% Decision variables (whole hours)
var 0..max_facility: x;  % hours on exercise X
var 0..max_facility: y;  % hours on exercise Y

% Constraints
constraint x + y >= min_total_time;
constraint 2*x + y <= max_facility;

% Objective: minimize total cost
var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];