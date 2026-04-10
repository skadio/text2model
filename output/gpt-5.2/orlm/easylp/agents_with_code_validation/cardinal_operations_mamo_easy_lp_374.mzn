% Parameters
% Cost per unit for each process (embedded from problem statement)
int: c1 = 2;
int: c2 = 3;
int: c3 = 5;
int: c4 = 7;

% Explicit bounds (embedded from problem statement)
int: x1_lb = 0;    int: x1_ub = 100;
int: x2_lb = 0;    int: x2_ub = 200;
int: x3_lb = 0;    int: x3_ub = 150;
int: x4_lb = -100; int: x4_ub = 300;

% Constraint constants (embedded from problem statement)
int: cap_x1_x2 = 150;     % x1 + x2 <= 150
int: min_diff_x3_x4 = 30; % x3 >= x4 + 30
int: rhs_c3 = 20;         % (1/2)x1 - (3/4)x4 <= 20
int: rhs_c4 = -50;        % (1/4)x3 - x2 >= -50

% Variables
var x1_lb..x1_ub: x1;  % resource allocation to process 1 (integer)
var x2_lb..x2_ub: x2;  % resource allocation to process 2 (integer)
var x3_lb..x3_ub: x3;  % resource allocation to process 3 (integer)
var x4_lb..x4_ub: x4;  % resource allocation to process 4 (integer)

% Constraints

% Capacity constraint: combined resources for processes 1 and 2 cannot exceed limit
constraint x1 + x2 <= cap_x1_x2;

% Process relationship: process 3 must be at least 30 more than process 4
constraint x3 >= x4 + min_diff_x3_x4;

% Fractional constraint without coercion:
% (1/2)x1 - (3/4)x4 <= 20  => multiply by 4: 2*x1 - 3*x4 <= 80
constraint 2 * x1 - 3 * x4 <= 4 * rhs_c3;

% Quarter relation constraint without coercion:
% (1/4)x3 - x2 >= -50  => multiply by 4: x3 - 4*x2 >= -200
constraint x3 - 4 * x2 >= 4 * rhs_c4;

% Objective
solve minimize c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;