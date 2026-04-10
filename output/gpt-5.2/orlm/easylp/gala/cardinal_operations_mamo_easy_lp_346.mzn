% Finance portfolio allocation - minimize total risk
include "globals.mzn";

% Data (embedded from problem statement)
array[1..4] of int: risk = [5, 7, 6, 8];  % risks for x1..x4

% Decision variables: dollars invested (whole numbers)
% Bounds were mentioned but not provided numerically; use safe nonnegative bounds
var 0..100000: x1;
var 0..100000: x2;
var 0..100000: x3;
var 0..100000: x4;

% Constraints
constraint 3*x1 + 4*x2 <= 5000;
constraint 2*x1 + 5*x3 <= 6000;

% "difference between x2 and x4 must be at least 1000"
constraint abs(x2 - x4) >= 1000;

% "difference between x1 and three times x3 should not exceed 2000"
constraint abs(x1 - 3*x3) <= 2000;

% Objective: minimize total risk score
var int: total_risk = risk[1]*x1 + risk[2]*x2 + risk[3]*x3 + risk[4]*x4;

solve minimize total_risk;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "minimum_total_risk=", show(total_risk), "\n"
];