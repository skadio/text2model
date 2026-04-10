% Shift scheduling with integer hours for groups X and Y

int: max_constraint = 40;
int: min_constraint = 30;

int: costX = 8;
int: costY = 12;

var 0..100: x; % hours for group X (integer)
var 0..100: y; % hours for group Y (integer)

constraint 2*x + 3*y <= max_constraint;
constraint 4*x + y >= min_constraint;

var int: total_cost = costX*x + costY*y;

solve minimize total_cost;

output [
  "x_hours=", show(x), "\n",
  "y_hours=", show(y), "\n",
  "min_total_cost_dollars=", show(total_cost), "\n"
];