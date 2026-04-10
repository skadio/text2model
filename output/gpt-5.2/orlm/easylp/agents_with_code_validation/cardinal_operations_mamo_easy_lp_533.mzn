% Parameters
% Cost per unit for each project
int: cost_x1 = 10;
int: cost_x2 = 20;
int: cost_x3 = 30;

% Constraint right-hand sides
int: c1_rhs = 2000;  % x1 + 2*x2 <= 2000
int: c2_rhs = 1000;  % 3*x1 + 4*x3 >= 1000
int: c3_rhs = 500;   % x2 - 5*x3 <= 500

% Variables
% Resource allocations (integers, non-negative) with safe upper bounds
var 0..c1_rhs: x1;                   % Project X1 allocation
var 0..(c1_rhs div 2): x2;            % Project X2 allocation
var 0..(c1_rhs div 2): x3;            % Project X3 allocation (safe upper bound)

% Total cost variable (explicit upper bound for tighter propagation)
var 0..(cost_x1*c1_rhs + cost_x2*(c1_rhs div 2) + cost_x3*(c1_rhs div 2)): total_cost;

% Constraints
% Budget/operational limit: x1 + 2*x2 <= 2000
constraint x1 + 2 * x2 <= c1_rhs;

% Minimum operational requirement: 3*x1 + 4*x3 >= 1000
constraint 3 * x1 + 4 * x3 >= c2_rhs;

% Difference limit: x2 - 5*x3 <= 500
constraint x2 - 5 * x3 <= c3_rhs;

% Total cost definition
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Objective
solve minimize total_cost;