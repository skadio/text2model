% Parameters
% Cost coefficients for each department allocation variable
int: c1 = 5;   % cost per unit for electronics (x1)
int: c2 = 3;   % cost per unit for clothing (x2)
int: c3 = 2;   % cost per unit for groceries (x3)
int: c4 = 7;   % cost per unit for home goods (x4)

% Constraint right-hand sides / thresholds
int: rhs_2x1_3x2_max    = 150; % 2*x1 + 3*x2 <= 150
int: rhs_x1_x4_min      = 30;  % x1 + x4 >= 30
int: diff_x3_x4_max     = 10;  % x3 - x4 <= 10
int: rhs_4x1_5x2_x3_min = 80;  % 4*x1 + 5*x2 + x3 >= 80

% Variable bounds (assume non-negative as not specified)
int: lb_x1 = 0;
int: lb_x2 = 0;
int: lb_x3 = 0;
int: lb_x4 = 0;

% Upper bounds not specified; use a safe, finite bound
int: ub = 1000;

% Variables
var lb_x1..ub: x1;  % allocation to electronics
var lb_x2..ub: x2;  % allocation to clothing
var lb_x3..ub: x3;  % allocation to groceries
var lb_x4..ub: x4;  % allocation to home goods

% Constraints
% Budget/space cap: 2*x1 + 3*x2 <= 150
constraint 2 * x1 + 3 * x2 <= rhs_2x1_3x2_max;

% Minimum combined allocation for electronics and home goods: x1 + x4 >= 30
constraint x1 + x4 >= rhs_x1_x4_min;

% Difference limit between groceries and home goods (as stated): x3 - x4 <= 10
constraint x3 - x4 <= diff_x3_x4_max;

% Minimum weighted allocation requirement: 4*x1 + 5*x2 + x3 >= 80
constraint 4 * x1 + 5 * x2 + x3 >= rhs_4x1_5x2_x3_min;

% Objective
solve minimize c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;