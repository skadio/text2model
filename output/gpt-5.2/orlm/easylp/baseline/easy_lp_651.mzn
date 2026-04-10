% Real estate investment optimization (all data embedded)

var 0..50: x1;  % residential
var 0..50: x2;  % commercial
var 0..70: x3;  % industrial
var 0..70: x4;  % recreational

% Constraints
constraint x1 + x2 <= 50;
constraint x3 + x4 <= 70;

% ROI constraint:
% 0.5*x1 - 0.25*x2 + 0.15*x3 + 1.0*x4 >= 20
% Multiply by 20 to keep everything integer:
% 10*x1 - 5*x2 + 3*x3 + 20*x4 >= 400
constraint 10*x1 - 5*x2 + 3*x3 + 20*x4 >= 400;

% Diversification/risk constraint:
% 2.5*x2 + 0.75*x3 - x1 - x4 <= 30
% Multiply by 4:
% 10*x2 + 3*x3 - 4*x1 - 4*x4 <= 120
constraint 10*x2 + 3*x3 - 4*x1 - 4*x4 <= 120;

% Objective: minimize total cost
var int: total_cost = 500*x1 + 300*x2 + 200*x3 + 100*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "minimum_total_cost=$", show(total_cost), "\n"
];