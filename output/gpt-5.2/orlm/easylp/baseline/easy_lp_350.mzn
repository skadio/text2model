% Hospital resource allocation - embedded data

% Decision variables (integer allocations)
var 0..100: X1;
var 0..80:  X2;
var 0..60:  X3;
var 0..50:  X4;

% Constraints
constraint X1 + X2 <= 100;
constraint X2 + X3 >= 50;
constraint X3 - X4 <= 30;
constraint 10*X1 + 15*X2 - 5*X3 - 20*X4 >= 150;

% Objective: minimize total cost
% Use integer scaling to avoid floats: minimize 10 * cost
% cost = 0.5*X1 + 0.2*X2 + 0.3*X3 + 0.4*X4
var int: cost10 = 5*X1 + 2*X2 + 3*X3 + 4*X4;
solve minimize cost10;

% Rounded-to-nearest-whole-number total cost (units):
% cost = cost10 / 10
% rounding: floor(cost + 0.5) = floor((cost10/10) + 0.5) = floor((cost10 + 5)/10)
output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), " X4=", show(X4), "\n",
  "cost10=", show(cost10), "\n",
  "rounded_cost=", show( (cost10 + 5) div 10 ), "\n"
];