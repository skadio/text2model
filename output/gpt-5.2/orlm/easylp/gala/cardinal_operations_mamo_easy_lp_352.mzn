% Resource allocation for hospital departments X, Y, Z, W
% Minimize total cost subject to linear constraints.
% Report the minimum total cost rounded up to the nearest whole number.

include "globals.mzn";

% Decision variables: whole-number resource units
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;
var 0..1000: W;

% Constraints
constraint X + Y <= 100;
constraint Z + W <= 80;

constraint X + Z >= 50;
constraint Y + W >= 60;

% Costs per unit (as rational numbers to avoid floating issues)
% X: 0.2 = 1/5, Y: 0.3 = 3/10, Z: 0.1 = 1/10, W: 0.4 = 2/5
% Minimize total cost = (1/5)X + (3/10)Y + (1/10)Z + (2/5)W
% Multiply by 10 to make integer objective:
% 10*cost = 2X + 3Y + 1Z + 4W
var int: cost10 = 2*X + 3*Y + Z + 4*W;

solve minimize cost10;

% Round up to nearest whole number:
% cost = cost10 / 10, ceil(cost) = ceil(cost10/10) = (cost10 + 9) div 10
output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "MinCostExact=", show(cost10), "/10\n",
  "MinCostRoundedUp=", show( (cost10 + 9) div 10 ), "\n"
];