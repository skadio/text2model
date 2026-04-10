% Marketing budget allocation problem (all data embedded)

var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;
var 0..1000: W;

% Constraints
constraint X + Y <= 100;
constraint Z + W <= 200;
constraint X + Z >= 50;
constraint Y + W >= 70;

% Objective: minimize total cost
var int: total_cost = 10*X + 15*Y + 25*Z + 30*W;
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];