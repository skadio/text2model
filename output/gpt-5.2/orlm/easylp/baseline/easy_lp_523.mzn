% Resource allocation in a hospital: minimize total cost

var 0..100: X1; % surgery
var 0..100: X2; % internal medicine
var 0..100: X3; % diagnostics

constraint X1 + X2 + X3 <= 100;

% "twice X1 must exceed half of X2 by at least 30":
% 2*X1 >= 0.5*X2 + 30  <=> 4*X1 - X2 >= 60
constraint 4 * X1 - X2 >= 60;

% "X1 - half of X3 should not exceed 20":
% X1 - 0.5*X3 <= 20  <=> 2*X1 - X3 <= 40
constraint 2 * X1 - X3 <= 40;

% Costs in tenths of dollars to avoid floats: 0.5=5/10, 0.3=3/10, 0.7=7/10
var int: total_cost_tenths = 5 * X1 + 3 * X2 + 7 * X3;

solve minimize total_cost_tenths;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), "\n",
  "min_cost=$", show(total_cost_tenths div 10), ".", show(total_cost_tenths mod 10), "\n"
];