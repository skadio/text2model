% Parameters
% Cost coefficients (embedded from problem statement)
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Constraint RHS values (embedded)
int: ub_x1_x2 = 1000;     % x1 + x2 <= 1000
int: lb_x2_x3 = 500;      % x2 + x3 >= 500
int: ub_x3_half_x4 = 200; % x3 - 0.5*x4 <= 200
int: ub_last = 70;        % 0.8*x2 + x3 - x1 <= 70

% Per-channel upper bounds (not numerically specified; set to 1000 to keep bounded)
int: ub_x1 = 1000;
int: ub_x2 = 1000;
int: ub_x3 = 1000;
int: ub_x4 = 1000;

% Variables
var 0..ub_x1: x1; % allocation to channel 1 (integer, non-negative)
var 0..ub_x2: x2; % allocation to channel 2 (integer, non-negative)
var 0..ub_x3: x3; % allocation to channel 3 (integer, non-negative)
var 0..ub_x4: x4; % allocation to channel 4 (integer, non-negative)

% Objective variable (for clarity)
var int: total_cost; % 2*x1 + 3*x2 + 4*x3 + 5*x4


% Constraints
% --- Cost definition ---
constraint
  total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% --- Budget coupling constraints ---
constraint
  x1 + x2 <= ub_x1_x2;

constraint
  x2 + x3 >= lb_x2_x3;

% --- Cross-channel dependency constraints ---
% x3 - 0.5*x4 <= 200  -> multiply by 2 to avoid floats: 2*x3 - x4 <= 400
constraint
  2 * x3 - x4 <= 2 * ub_x3_half_x4;

% x1 >= 0.7*x4 -> multiply by 10 to avoid floats: 10*x1 >= 7*x4
constraint
  10 * x1 >= 7 * x4;

% 0.8*x2 + x3 - x1 <= 70 -> multiply by 5 to avoid floats: 4*x2 + 5*x3 - 5*x1 <= 350
constraint
  4 * x2 + 5 * x3 - 5 * x1 <= 5 * ub_last;


% Objective
solve minimize total_cost;