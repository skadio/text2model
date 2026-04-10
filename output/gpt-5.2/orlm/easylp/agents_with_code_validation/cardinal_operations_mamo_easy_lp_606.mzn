% Parameters
% Cost coefficients for each department allocation
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Constraint right-hand sides
int: max_x1_x2 = 1000;     % x1 + x2 <= 1000
int: min_x3_x4 = 500;      % x3 + x4 >= 500
int: rhs_balance_13 = 300; % 2*x1 - (1/2)*x3 >= -300  (handled as 4*x1 - x3 >= -600)
int: max_diff_124 = 400;   % (x1 + x2) - x4 <= 400

% Bounds (assume nonnegative)
int: lb1 = 0;
int: lb2 = 0;
int: lb3 = 0;
int: lb4 = 0;

% Conservative upper bounds derived from constraints to keep variables bounded
int: ub1 = max_x1_x2;                          % x1 <= 1000
int: ub2 = max_x1_x2;                          % x2 <= 1000
int: ub4_tight = max_x1_x2 + max_diff_124;     % x4 <= 1000 + 400 = 1400
int: ub3 = 4 * ub1 + 2 * rhs_balance_13;       % from 4*x1 - x3 >= -600 => x3 <= 4*x1 + 600, worst-case x1=1000 => 4600

% Variables
var lb1..ub1: x1;                 % resource allocation to department 1 (integer)
var lb2..ub2: x2;                 % resource allocation to department 2 (integer)
var lb3..ub3: x3;                 % resource allocation to department 3 (integer)
var lb4..ub4_tight: x4;           % resource allocation to department 4 (integer)

var int: total_cost;              % total cost to minimize (integer)

% Constraints
% --- Total cost definition (linking variable to decision variables) ---
constraint
  total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% --- Budget/Capacity constraint for departments 1 and 2 ---
constraint
  x1 + x2 <= max_x1_x2;

% --- Minimum critical allocation for departments 3 and 4 ---
constraint
  x3 + x4 >= min_x3_x4;

% --- Balance constraint between departments 1 and 3 ---
% Given: 2*x1 - (1/2)*x3 >= -300  ==> multiply by 2 to avoid fractions: 4*x1 - x3 >= -600
constraint
  4 * x1 - x3 >= -2 * rhs_balance_13;

% --- Balance constraint involving departments 1, 2, and 4 ---
constraint
  (x1 + x2) - x4 <= max_diff_124;

% Objective
solve minimize total_cost;