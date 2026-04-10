% Parameters
%--------------------------
% Cost coefficients for each unit (embedded as per instructions)
%--------------------------
int: c1 = 300;
int: c2 = 200;
int: c3 = 500;
int: c4 = 400;

%--------------------------
% Constraint right-hand sides / limits (embedded as per instructions)
%--------------------------
int: max_x1_x2 = 1000;          % x1 + x2 <= 1000
int: min_2x1_x3 = 800;          % 2*x1 + x3 >= 800
int: min_x2_m_halfx4 = 300;     % x2 - 0.5*x4 >= 300
int: max_x2_x3_minus_x1 = 70;   % x2 - x3 - x1 <= 70


% Variables
%--------------------------
% Resource allocations (whole numbers, non-negative)
%--------------------------
var int: x1; % allocation for unit 1
var int: x2; % allocation for unit 2
var int: x3; % allocation for unit 3
var int: x4; % allocation for unit 4

% Total cost to minimize
var int: total_cost;


% Constraints
%--------------------------
% Domain / integrality constraints (non-negativity)
%--------------------------
constraint x1 >= 0;
constraint x2 >= 0;
constraint x3 >= 0;
constraint x4 >= 0;

%--------------------------
% Operational requirement constraints
%--------------------------

% Combined allocation limit for units 1 and 2: x1 + x2 <= 1000
constraint x1 + x2 <= max_x1_x2;

% Critical requirement: 2*x1 + x3 >= 800
constraint 2 * x1 + x3 >= min_2x1_x3;

% Deployment strategy constraint:
% x2 - 0.5*x4 >= 300  <=>  2*x2 - x4 >= 600 (avoid fractional coefficient)
constraint 2 * x2 - x4 >= 2 * min_x2_m_halfx4;

% Balanced force composition: x2 - x3 - x1 <= 70
constraint x2 - x3 - x1 <= max_x2_x3_minus_x1;

%--------------------------
% Total cost definition
%--------------------------
constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;


% Objective
solve minimize total_cost;