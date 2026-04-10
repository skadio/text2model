% Budget allocation optimization (all data embedded)

int: TOTAL_BUDGET = 1000;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

int: minDiffXY = 200;  % X >= Y + 200
int: maxZ = 300;       % Z <= 300

var 0..TOTAL_BUDGET: X;
var 0..TOTAL_BUDGET: Y;
var 0..TOTAL_BUDGET: Z;

constraint X + Y + Z = TOTAL_BUDGET;
constraint X >= Y + minDiffXY;
constraint Z <= maxZ;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];