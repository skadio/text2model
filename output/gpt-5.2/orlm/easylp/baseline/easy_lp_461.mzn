int: MAX_TOTAL = 1000;

int: COST_X = 50;
int: COST_Y = 30;

int: MAX_X = 700;
int: MAX_Y = 500;

var 0..MAX_X: x;
var 0..MAX_Y: y;

constraint x + y <= MAX_TOTAL;
constraint 3*x - 2*y >= 0;
constraint x - y >= 200;

var int: total_cost = COST_X*x + COST_Y*y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];