% Parameters
int: n = 4;                               % number of portfolios (x1..x4)
set of int: P = 1..n;                     % portfolio indices

array[P] of int: risk = [5, 7, 6, 8];     % risk per $ invested in each portfolio

% Coefficients / RHS for constraints
int: c1_x1 = 3;  int: c1_x2 = 4;  int: rhs1 = 5000;    % 3*x1 + 4*x2 <= 5000
int: c2_x1 = 2;  int: c2_x3 = 5;  int: rhs2 = 6000;    % 2*x1 + 5*x3 <= 6000
int: minDiff24 = 1000;                                   % x2 - x4 >= 1000
int: rhs4 = 2000;                                        % x1 - 3*x3 <= 2000

% Bounds (description does not specify explicit numeric upper bounds; use non-negativity)
array[P] of int: lb = [0, 0, 0, 0];
array[P] of int: ub = [1000000, 1000000, 1000000, 1000000];

% Variables
array[P] of var int: x;                   % investments in portfolios x1..x4 (whole dollars)
var int: total_risk = sum(i in P)(risk[i] * x[i]);

% Constraints

% -----------------------------
% Investment bounds (integral $ already enforced by var int)
% -----------------------------
constraint forall(i in P) (x[i] >= lb[i]);
constraint forall(i in P) (x[i] <= ub[i]);

% -----------------------------
% Regulatory / policy constraints
% -----------------------------

% 3*x1 + 4*x2 <= 5000
constraint c1_x1 * x[1] + c1_x2 * x[2] <= rhs1;

% 2*x1 + 5*x3 <= 6000
constraint c2_x1 * x[1] + c2_x3 * x[3] <= rhs2;

% x2 - x4 >= 1000
constraint x[2] - x[4] >= minDiff24;

% x1 - 3*x3 <= 2000
constraint x[1] - 3 * x[3] <= rhs4;

% Objective
solve minimize total_risk;