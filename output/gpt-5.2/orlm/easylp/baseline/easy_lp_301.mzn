% Environmental projects cost minimization (all data embedded)

int: costX = 5;
int: costY = 3;
int: costZ = 2;

% Upper bounds derived from constraints to keep the model finite
var 0..20: X;
var 0..20: Y;
var 0..15: Z;

constraint X + Y <= 20;
constraint 2*Y + Z >= 10;
constraint X + Z <= 15;

var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "min_total_cost=", show(total_cost), "\n",
  "rounded_min_total_cost=", show(total_cost), "\n"
];