% Resource allocation optimization (all data embedded)

int: BUDGET = 1000;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

constraint X + Y + Z <= BUDGET;

% X must be at least twice Y plus 200
constraint X >= 2 * Y + 200;

% Z must be at least Y plus 100
constraint Z >= Y + 100;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];