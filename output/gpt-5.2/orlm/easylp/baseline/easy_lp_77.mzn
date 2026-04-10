% Manpower allocation for tasks X and Y (integer hours)

int: max_effort = 120;
int: min_total_hours = 40;

int: cost_x = 50;
int: cost_y = 30;

var 0..1000: x; % hours on task X
var 0..1000: y; % hours on task Y

constraint 2*x + 3*y <= max_effort;
constraint x + y >= min_total_hours;

var int: total_cost = cost_x*x + cost_y*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_total_cost = $", show(total_cost), "\n"
];