% Parameters
int: c1 = 10;                 % Cost per unit for X1
int: c2 = 15;                 % Cost per unit for X2
int: c3 = 20;                 % Cost per unit for X3
int: c4 = 25;                 % Cost per unit for X4

int: min_x1x2 = 200;          % Minimum combined allocation for X1 + X2
int: max_diff_x3x4 = 50;      % Maximum allowed absolute difference |X3 - X4|
int: ineq_rhs = 100;          % RHS for: 2*X2 - X1 - 0.5*X3 <= 100
int: eq_offset = 150;         % Offset in: (3/4)*X1 = X4 + 150
int: total_cap = 500;         % Maximum total allocation X1+X2+X3+X4

int: x1_lb = 0; int: x1_ub = 300;  % Bounds for X1
int: x2_lb = 0; int: x2_ub = 250;  % Bounds for X2
int: x3_lb = 0; int: x3_ub = 400;  % Bounds for X3
int: x4_lb = 0; int: x4_ub = 350;  % Bounds for X4


% Variables
var x1_lb..x1_ub: x1;         % Allocation for unit X1 (integer)
var x2_lb..x2_ub: x2;         % Allocation for unit X2 (integer)
var x3_lb..x3_ub: x3;         % Allocation for unit X3 (integer)
var x4_lb..x4_ub: x4;         % Allocation for unit X4 (integer)

var int: total_cost;          % Total cost to minimize


% Constraints

% Minimum combined allocation for units X1 and X2
constraint x1 + x2 >= min_x1x2;

% Balance requirement between units X3 and X4 (absolute difference)
constraint abs(x3 - x4) <= max_diff_x3x4;

% Linear inequality: 2*X2 - X1 - 0.5*X3 <= 100
% Multiply by 2 to avoid fractional coefficient:
% 4*X2 - 2*X1 - X3 <= 2*ineq_rhs
constraint 4 * x2 - 2 * x1 - x3 <= 2 * ineq_rhs;

% Exact ratio constraint: (3/4)*X1 = X4 + 150
% Multiply by 4 to avoid fractions:
% 3*X1 = 4*X4 + 4*eq_offset
constraint 3 * x1 = 4 * x4 + 4 * eq_offset;

% Total capacity across all units
constraint x1 + x2 + x3 + x4 <= total_cap;

% Define total cost
constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;


% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=$", show(total_cost), "\n"
];