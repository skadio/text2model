% Manpower allocation between Project X and Project Y
% All data embedded as requested.

int: max_total_people = 100;
int: min_x = 20;
int: min_y = 10;

int: cost_x = 50;
int: cost_y = 30;

% Decision variables (integers)
var 0..max_total_people: x; % people assigned to Project X
var 0..max_total_people: y; % people assigned to Project Y

% Constraints
constraint x + y <= max_total_people;
constraint x >= min_x;
constraint y >= min_y;

% Objective: minimize total cost
var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];