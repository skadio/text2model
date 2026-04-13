% Scheduling allocation: minimize cost with integer hours

int: total_hours_limit = 40;
int: min_effort = 20;
int: diff_limit = 10;

int: max_x = 25;
int: max_y = 15;

int: cost_x = 8;
int: cost_y = 10;

var 0..max_x: x; % hours for Task X
var 0..max_y: y; % hours for Task Y

constraint x + y <= total_hours_limit;
constraint 2 * x + y >= min_effort;
constraint abs(x - y) <= diff_limit;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];