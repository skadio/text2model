int: MAX_TOTAL = 1000;
int: MIN_2X_PLUS_Y = 200;
int: MAX_X_PLUS_Z = 300;

int: COST_X = 5;
int: COST_Y = 4;
int: COST_Z = 3;

var 0..MAX_TOTAL: X;
var 0..MAX_TOTAL: Y;
var 0..MAX_TOTAL: Z;

constraint X + Y + Z <= MAX_TOTAL;
constraint 2*X + Y >= MIN_2X_PLUS_Y;
constraint X + Z <= MAX_X_PLUS_Z;

var int: total_cost = COST_X*X + COST_Y*Y + COST_Z*Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];