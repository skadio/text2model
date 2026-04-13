% Parameters
int: budget = 100000;                 % Total budget upper bound

int: x1_min = 10000;                  % Minimum investment in X1
int: x1_max = 60000;                  % Maximum investment in X1

int: x2_min = 20000;                  % Minimum investment in X2
int: x2_max = 80000;                  % Maximum investment in X2

int: x3_min = 15000;                  % Minimum investment in X3
int: x3_max = 50000;                  % Maximum investment in X3

int: x4_min = 200;                    % Minimum investment in X4
int: x4_max = budget;                 % Practical upper bound (no explicit upper limit, bounded by budget)

float: c1 = 0.05;                     % Cost rate for X1
float: c2 = 0.08;                     % Cost rate for X2
float: c3 = 0.12;                     % Cost rate for X3
float: c4 = 0.15;                     % Cost rate for X4

int: diff_x3x4_vs_x1x2_limit = 30000; % Limit in constraint involving (X3+X4) vs (X1+X2)
int: x3x4_diff_limit = 500;           % Limit for (0.70*X3 - 0.50*X4) <= 500


% Variables
var x1_min..x1_max: x1;               % Investment in asset X1 (integer dollars)
var x2_min..x2_max: x2;               % Investment in asset X2 (integer dollars)
var x3_min..x3_max: x3;               % Investment in asset X3 (integer dollars)
var x4_min..x4_max: x4;               % Investment in asset X4 (integer dollars)

% Total cost (bounded using variable upper bounds)
var 0.0..(c1*int2float(x1_max) + c2*int2float(x2_max) + c3*int2float(x3_max) + c4*int2float(x4_max)): total_cost;


% Constraints

% --- Budget constraint: total investment cannot exceed the available budget
constraint
  x1 + x2 + x3 + x4 <= budget;

% --- Individual investment bounds (redundant with variable domains, kept for clarity/maintenance)
constraint x1_min <= x1 /\ x1 <= x1_max;
constraint x2_min <= x2 /\ x2 <= x2_max;
constraint x3_min <= x3 /\ x3 <= x3_max;
constraint x4_min <= x4 /\ x4 <= x4_max;

% --- Relationship constraint 1:
% 0.60*X1 - 0.40*X2 >= 0  ==>  3*X1 - 2*X2 >= 0 (scaled to avoid floats)
constraint
  3 * x1 - 2 * x2 >= 0;

% --- Relationship constraint 2:
% (X3 + X4) should not be less than (X1 + X2) by more than 30000
% (X1 + X2) - (X3 + X4) <= 30000
constraint
  (x1 + x2) - (x3 + x4) <= diff_x3x4_vs_x1x2_limit;

% --- Relationship constraint 3:
% 0.70*X3 - 0.50*X4 <= 500  ==>  7*X3 - 5*X4 <= 5000 (scaled by 10)
constraint
  7 * x3 - 5 * x4 <= 10 * x3x4_diff_limit;

% --- Total cost definition (kept in float domain)
constraint
  total_cost = c1 * int2float(x1)
             + c2 * int2float(x2)
             + c3 * int2float(x3)
             + c4 * int2float(x4);


% Objective
solve minimize total_cost;