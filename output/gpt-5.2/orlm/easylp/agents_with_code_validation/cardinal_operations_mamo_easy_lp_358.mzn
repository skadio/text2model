% Parameters
int: cost_x1 = 2;                      % Unit cost for department X1
int: cost_x2 = 3;                      % Unit cost for department X2
int: cost_x3 = 4;                      % Unit cost for department X3
int: cost_x4 = 5;                      % Unit cost for department X4

int: max_x1_x2 = 2000;                 % Upper bound on X1 + X2
int: min_2x3_3x4 = 3000;               % Lower bound on 2*X3 + 3*X4
int: max_diff_x1_x4 = 500;             % Upper bound on (X1 - X4)
int: min_x2_minus_x3 = 1000;           % Lower bound on (X2 - X3)

% Variable bounds (non-negative; explicit tight bounds not provided)
int: lb_x1 = 0;
int: lb_x2 = 0;
int: lb_x3 = 0;
int: lb_x4 = 0;

int: ub_x1 = 1000000;                  % Large safe upper bounds
int: ub_x2 = 1000000;
int: ub_x3 = 1000000;
int: ub_x4 = 1000000;

% Variables
var lb_x1..ub_x1: x1;                  % Funds allocated to department X1 (integer)
var lb_x2..ub_x2: x2;                  % Funds allocated to department X2 (integer)
var lb_x3..ub_x3: x3;                  % Funds allocated to department X3 (integer)
var lb_x4..ub_x4: x4;                  % Funds allocated to department X4 (integer)

var int: total_expenditure;            % Total cost to be minimized

% Constraints
% --- Budget limit on combined allocation to departments X1 and X2 ---
constraint x1 + x2 <= max_x1_x2;

% --- Operational requirement linking departments X3 and X4 ---
constraint 2 * x3 + 3 * x4 >= min_2x3_3x4;

% --- Balance requirement: difference between X1 and X4 must not exceed the limit ---
constraint x1 - x4 <= max_diff_x1_x4;

% --- Strategic focus: X2 must exceed X3 by at least the required margin ---
constraint x2 - x3 >= min_x2_minus_x3;

% --- Define total expenditure from per-unit costs and allocations ---
constraint total_expenditure =
    cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_expenditure;