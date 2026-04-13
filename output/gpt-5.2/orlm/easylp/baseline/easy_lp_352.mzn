% Hospital resource allocation (integer units), minimize total cost.
% Data embedded as requested.

var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;
var 0..1000: W;

constraint X + Y <= 100;
constraint Z + W <= 80;

constraint X + Z >= 50;
constraint Y + W >= 60;

% Costs: X=0.2, Y=0.3, Z=0.1, W=0.4
% Multiply by 10 to avoid floating point: minimize 2X + 3Y + 1Z + 4W
var int: cost10 = 2*X + 3*Y + 1*Z + 4*W;

solve minimize cost10;

% Rounded-up total cost in original units:
% ceil(cost10 / 10) = (cost10 + 9) div 10 for nonnegative integers.
output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "TotalCostExact=", show(cost10), "/10\n",
  "MinimumTotalCostRoundedUp=", show((cost10 + 9) div 10), "\n"
];