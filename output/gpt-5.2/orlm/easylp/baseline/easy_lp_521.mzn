% Portfolio allocation optimization (all data embedded)

var int: X;
var int: Y;
var int: Z;

% Constraints
constraint 2*X + Y + Z >= 10;
constraint X - Y + 2*Z <= 15;
constraint X = Y + 3;
constraint X + Y + Z <= 20;

% Nonnegativity (implicit in "amount invested")
constraint X >= 0 /\ Y >= 0 /\ Z >= 0;

% Costs
int: cX = 7;
int: cY = 3;
int: cZ = 5;

var int: total_cost = cX*X + cY*Y + cZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "min_cost_rounded=", show(round(total_cost)), "\n",
  "min_cost=", show(total_cost), "\n"
];