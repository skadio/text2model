% Cargo allocation cost minimization (all data embedded)

int: CAPACITY = 500;

int: MIN_X = 200;
int: MIN_Y = 100;

float: COST_X = 0.05;
float: COST_Y = 0.1;

var int: x;
var int: y;

constraint x >= MIN_X;
constraint y >= MIN_Y;
constraint x + y <= CAPACITY;

var float: total_cost = COST_X * int2float(x) + COST_Y * int2float(y);

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost_rounded_1dp=", show(round(total_cost * 10.0) / 10.0), "\n"
];