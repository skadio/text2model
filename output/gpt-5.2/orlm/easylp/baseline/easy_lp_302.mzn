% Environmental agency fund allocation problem (all data embedded)

var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Constraints
constraint X + Y + Z <= 1000;
constraint X - 2*Y + Z >= 200;
constraint 2*X + Y - Z <= 500;

% Objective: minimize total cost
var int: total_cost = 50*X + 30*Y + 20*Z;
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];