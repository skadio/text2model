% Transportation resource allocation (all data embedded)

int: TOTAL_CAPACITY = 2000;
int: MIN_X = 800;
int: MIN_Y = 500;

int: COST_X = 50;
int: COST_Y = 30;

var int: x; % units allocated to route X
var int: y; % units allocated to route Y

constraint x >= MIN_X;
constraint y >= MIN_Y;
constraint x + y <= TOTAL_CAPACITY;

var int: total_cost = COST_X * x + COST_Y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];