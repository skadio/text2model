int: budget = 5000;
int: min_effect = 10000;

int: costX = 10;
int: costY = 20;

int: effX = 2;
int: effY = 3;

var 0..budget: X;
var 0..budget: Y;

constraint X + Y <= budget;
constraint effX * X + effY * Y >= min_effect;

var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];