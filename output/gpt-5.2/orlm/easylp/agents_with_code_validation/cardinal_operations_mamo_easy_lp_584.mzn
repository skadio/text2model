% Parameters
int: max_x1_x2 = 1000;              % x1 + x2 <= 1000
int: max_2x3_3x4 = 1500;            % 2*x3 + 3*x4 <= 1500
int: min_x1_minus_half_x3 = 300;    % x1 - (x3/2) >= 300  (handled without fractions)
int: max_x4_minus_x2 = 400;         % x4 - x2 <= 400

int: cost_x1 = 50;                  % cost per unit for x1
int: cost_x2 = 60;                  % cost per unit for x2
int: cost_x3 = 30;                  % cost per unit for x3
int: cost_x4 = 20;                  % cost per unit for x4

int: ub_x1 = 800;                   % upper bound for x1
int: ub_x2 = 700;                   % upper bound for x2
int: ub_x3 = 500;                   % upper bound for x3
int: ub_x4 = 200;                   % upper bound for x4


% Variables
var 0..ub_x1: x1;  % integer allocation to channel x1
var 0..ub_x2: x2;  % integer allocation to channel x2
var 0..ub_x3: x3;  % integer allocation to channel x3
var 0..ub_x4: x4;  % integer allocation to channel x4

% total cost (safe linear upper bound from variable domains)
var 0..(cost_x1*ub_x1 + cost_x2*ub_x2 + cost_x3*ub_x3 + cost_x4*ub_x4): total_cost;


% Constraints
% Total allocation limit for channels x1 and x2
constraint x1 + x2 <= max_x1_x2;

% Weighted allocation limit for channels x3 and x4
constraint 2 * x3 + 3 * x4 <= max_2x3_3x4;

% Minimum separation: x1 exceeds half of x3 by at least 300
% Multiply by 2 to avoid fractions: 2*x1 - x3 >= 2*300
constraint 2 * x1 - x3 >= 2 * min_x1_minus_half_x3;

% Difference bound: x4 - x2 should not surpass 400
constraint x4 - x2 <= max_x4_minus_x2;

% Define total cost
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;