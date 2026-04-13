% Resource allocation between two projects X and Y
% Minimize total cost subject to constraints, with all data embedded.

int: max_total_resources = 200;
int: min_combined_requirement = 100;
int: max_balance_diff = 50;

int: max_x = 150;
int: max_y = 100;

int: cost_x = 5000;
int: cost_y = 3000;

var 0..max_x: x; % resources for project X (integer units)
var 0..max_y: y; % resources for project Y (integer units)

constraint x + y <= max_total_resources;
constraint 2*x + y >= min_combined_requirement;
constraint abs(x - y) <= max_balance_diff;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = $", show(total_cost), "\n"
];