% Employee allocation between Project X and Project Y
% Minimize daily staffing cost subject to manpower/resource constraints.

% Data (embedded from problem statement)
int: min_total = 20;
int: max_resource = 40;          % 2*X + Y <= 40
int: costX = 50;
int: costY = 80;

% Decision variables (number of employees)
var 0..max_resource: x;          % employees on Project X
var 0..max_resource: y;          % employees on Project Y

% Constraints
constraint x + y >= min_total;
constraint 2*x + y <= max_resource;

% Objective
var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_daily_cost = $", show(total_cost), "\n"
];