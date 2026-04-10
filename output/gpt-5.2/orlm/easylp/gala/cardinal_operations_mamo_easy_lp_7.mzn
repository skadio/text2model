% Marketing resource allocation (integer linear optimization)

int: BUDGET_MAX = 5000;
int: EFFECT_MIN = 10000;

int: costX = 10;
int: costY = 20;

int: effX = 2;
int: effY = 3;

/* Decision variables (resources allocated) */
var 0..BUDGET_MAX: X;
var 0..BUDGET_MAX: Y;

/* Constraints */
constraint X + Y <= BUDGET_MAX;
constraint effX * X + effY * Y >= EFFECT_MIN;

/* Objective: minimize total cost */
var int: totalCost = costX * X + costY * Y;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost (rounded) = ", show(totalCost), "\n"
];