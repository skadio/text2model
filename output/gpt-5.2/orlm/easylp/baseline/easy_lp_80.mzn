% Resource allocation between tasks X and Y: minimize total cost

int: hours_available = 20;
int: hours_per_X = 5;
int: hours_per_Y = 3;

int: prod_min = 10;
int: prod_per_X = 2;
int: prod_per_Y = 4;

int: cost_per_X = 50;
int: cost_per_Y = 80;

var 0..hours_available div hours_per_X: X;
var 0..hours_available div hours_per_Y: Y;

constraint hours_per_X * X + hours_per_Y * Y <= hours_available;
constraint prod_per_X * X + prod_per_Y * Y >= prod_min;

var int: total_cost = cost_per_X * X + cost_per_Y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Total cost ($) = ", show(total_cost), "\n"
];