% Parameters
% Costs per unit allocation for each project
int: cost_x1 = 4;
int: cost_x2 = 5;
int: cost_x3 = 6;
int: cost_x4 = 7;

% Constraint constants
int: max_x1_x2 = 1000;            % x1 + x2 <= 1000
int: min_x2_x3 = 800;             % x2 + x3 >= 800
int: diff_x3_x4 = 200;            % x3 - x4 = 200
int: max_halfx4_minus_x1 = 300;   % (x4/2) - x1 <= 300  (scaled form used)

% Lower bound on allocations (non-negative)
int: lb = 0;

% Variables
var int: x1; % Resource allocation for Project X1
var int: x2; % Resource allocation for Project X2
var int: x3; % Resource allocation for Project X3
var int: x4; % Resource allocation for Project X4

var int: total_cost; % Total cost to minimize

% Constraints

%-----------------------------
% Resource allocation bounds
%-----------------------------
constraint x1 >= lb;
constraint x2 >= lb;
constraint x3 >= lb;
constraint x4 >= lb;

%-----------------------------
% Budget / policy constraints
%-----------------------------

% Combined allocation for Project X1 and X2 cannot exceed the limit
constraint x1 + x2 <= max_x1_x2;

% Ensure minimum combined allocation for Project X2 and X3
constraint x2 + x3 >= min_x2_x3;

% Exact difference requirement between Project X3 and X4
constraint x3 - x4 = diff_x3_x4;

% Half of X4 minus X1 must not exceed the limit (scaled to avoid fractions)
% (x4/2) - x1 <= max_halfx4_minus_x1  <=>  x4 - 2*x1 <= 2*max_halfx4_minus_x1
constraint x4 - 2 * x1 <= 2 * max_halfx4_minus_x1;

%-----------------------------
% Total cost calculation
%-----------------------------
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;