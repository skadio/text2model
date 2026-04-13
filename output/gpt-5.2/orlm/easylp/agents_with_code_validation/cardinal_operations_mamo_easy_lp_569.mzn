% Parameters
% Cost per unit of resource allocated to each project
int: cost_X1 = 4;
int: cost_X2 = 5;
int: cost_X3 = 6;

% Constraint coefficients / right-hand sides
int: cap_X1_2X2 = 1000;              % X1 + 2*X2 <= 1000
int: min_X2_3X3 = 600;               % X2 + 3*X3 >= 600
int: balance_2X3_minus_X1 = 500;     % 2*X3 - X1 == 500

% Derived safe bounds (to ensure all vars are bounded integers)
% From X1 + 2*X2 <= 1000 and nonnegativity: X1 <= 1000, X2 <= 500
int: X1_ub = cap_X1_2X2;
int: X2_ub = cap_X1_2X2 div 2;

% From 2*X3 - X1 == 500 and X1 >= 0 => X3 >= 250
int: X3_lb = balance_2X3_minus_X1 div 2;
% From X1 <= 1000: 2*X3 = X1 + 500 <= 1500 => X3 <= 750
int: X3_ub = (X1_ub + balance_2X3_minus_X1) div 2;


% Variables
var 0..X1_ub: X1;       % resource allocation for project X1 (integer, nonnegative)
var 0..X2_ub: X2;       % resource allocation for project X2 (integer, nonnegative)
var X3_lb..X3_ub: X3;   % resource allocation for project X3 (integer, bounded via equality)


% Constraints
% Capacity constraint: combined allocation for X1 and twice X2 must not exceed limit
constraint
  X1 + 2 * X2 <= cap_X1_2X2;

% Minimum requirement constraint: allocation for X2 plus thrice X3 must meet minimum
constraint
  X2 + 3 * X3 >= min_X2_3X3;

% Balance/equality constraint: twice X3 minus X1 must equal the required balance
constraint
  2 * X3 - X1 = balance_2X3_minus_X1;


% Objective
solve minimize cost_X1 * X1 + cost_X2 * X2 + cost_X3 * X3;

% Optional output for inspection
output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "TotalCost=", show(cost_X1*X1 + cost_X2*X2 + cost_X3*X3), "\n"
];