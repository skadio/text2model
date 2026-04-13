% Parameters
% Resource allocation upper bounds (units)
int: max_x1 = 800;
int: max_x2 = 700;
int: max_x3 = 500;
int: max_x4 = 200;

% Constraint limits (units)
int: limit_x1_x2 = 1000;                 % x1 + x2 <= 1000
int: limit_2x3_3x4 = 1500;               % 2*x3 + 3*x4 <= 1500
int: min_margin_x1_vs_half_x3 = 300;     % x1 - (x3/2) >= 300
int: max_diff_x4_x2 = 400;               % x4 - x2 <= 400

% Costs per unit (cost units per resource unit)
int: cost_x1 = 50;
int: cost_x2 = 60;
int: cost_x3 = 30;
int: cost_x4 = 20;


% Variables
% Whole-number allocations to each channel (units)
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

% Total cost (integer because all costs and allocations are integer)
var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3 + cost_x4*max_x4): total_cost;


% Constraints
% Combined allocation to x1 and x2
constraint x1 + x2 <= limit_x1_x2;

% Weighted combined allocation for x3 and x4
constraint 2 * x3 + 3 * x4 <= limit_2x3_3x4;

% Avoid fractional division by rewriting:
% x1 - x3/2 >= 300  <=>  2*x1 - x3 >= 600
constraint 2 * x1 - x3 >= 2 * min_margin_x1_vs_half_x3;

% The difference between allocations for x4 and x2 should not surpass 400 units
constraint x4 - x2 <= max_diff_x4_x2;

% Total cost definition
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;