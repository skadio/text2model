int: capacity = 100;
int: min_value = 150;

int: costX = 4;
int: costY = 5;

int: valueX = 2;
int: valueY = 3;

var 0..capacity: x; % tons of cargo X (integer)
var 0..capacity: y; % tons of cargo Y (integer)

constraint x + y <= capacity;
constraint valueX * x + valueY * y >= min_value;

var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];