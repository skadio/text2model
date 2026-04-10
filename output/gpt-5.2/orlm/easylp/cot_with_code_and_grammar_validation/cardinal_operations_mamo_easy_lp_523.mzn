% Parameters
int: TOTAL_MAX = 100;

int: X1_LB = 0;
int: X1_UB = 100;
int: X2_LB = 0;
int: X2_UB = 100;
int: X3_LB = 0;
int: X3_UB = 100;

% Costs in tenths of dollars to avoid floats:
% 0.5 -> 5, 0.3 -> 3, 0.7 -> 7
int: C1_10 = 5;
int: C2_10 = 3;
int: C3_10 = 7;

% Variables
var X1_LB..X1_UB: X1;
var X2_LB..X2_UB: X2;
var X3_LB..X3_UB: X3;

var 0..(C1_10*X1_UB + C2_10*X2_UB + C3_10*X3_UB): total_cost_10;

% Constraints
constraint X1 + X2 + X3 <= TOTAL_MAX;

% 2*X1 must exceed 0.5*X2 by at least 30:
% 2*X1 - 0.5*X2 >= 30  <=>  4*X1 - X2 >= 60
constraint 4*X1 - X2 >= 60;

% X1 - 0.5*X3 <= 20  <=>  2*X1 - X3 <= 40
constraint 2*X1 - X3 <= 40;

constraint total_cost_10 = C1_10*X1 + C2_10*X2 + C3_10*X3;

% Objective
solve minimize total_cost_10;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "min_cost=$", show(total_cost_10 div 10), ".", show(total_cost_10 mod 10), "\n"
];