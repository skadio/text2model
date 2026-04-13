% Investment planning for renewable energy projects X and Y

int: budget = 5000;

int: outputX = 10;
int: outputY = 30;
int: requiredOutput = 20000;

int: costX = 50;
int: costY = 60;

var 0..budget: x;  % whole-number investment units in project X
var 0..budget: y;  % whole-number investment units in project Y

constraint x + y <= budget;
constraint outputX * x + outputY * y >= requiredOutput;

var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];