% Resource allocation across tasks X, Y, Z (integer units)

var 0..20: X;
var 0..20: Y;
var 0..20: Z;

% Constraints
constraint X + Y + Z <= 20;
constraint 2*X + Y >= 5;
constraint Y - Z <= 10;

% Costs per unit
int: costX = 100;
int: costY = 200;
int: costZ = 150;

var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "min_total_cost=$", show(total_cost), "\n"
];