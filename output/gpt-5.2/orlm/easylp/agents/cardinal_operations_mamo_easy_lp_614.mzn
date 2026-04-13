% Parameters
int: cost_x1 = 100;         % Cost per unit for task x1
int: cost_x2 = 200;         % Cost per unit for task x2
int: cost_x3 = 300;         % Cost per unit for task x3
int: cost_x4 = 400;         % Cost per unit for task x4

int: max_x1_plus_x2 = 30;      % Upper bound for x1 + x2
int: min_2x1_plus_x3 = 40;     % Lower bound for 2*x1 + x3
int: x4_minus_x2_eq = 20;      % Equality requirement: x4 - x2 = 20
int: min_x1_plus_half_x3 = 10; % Lower bound for x1 + 0.5*x3

% Variables
var 0..30: x1;              % Resources allocated to task x1
var 0..30: x2;              % Resources allocated to task x2
var 0..40: x3;              % Resources allocated to task x3
var 0..50: x4;              % Resources allocated to task x4

% Constraints
% Manpower/equipment limitation: x1 + x2 cannot exceed the given maximum
constraint x1 + x2 <= max_x1_plus_x2;

% Milestone requirement: 2*x1 + x3 must be at least the given minimum
constraint 2 * x1 + x3 >= min_2x1_plus_x3;

% Sequential dependency: x4 - x2 must equal the given constant
constraint x4 - x2 = x4_minus_x2_eq;

% Quality/safety requirement: x1 + 0.5*x3 >= minimum
% Avoid fractional arithmetic: 2*x1 + x3 >= 2*minimum
constraint 2 * x1 + x3 >= 2 * min_x1_plus_half_x3;

% Objective
solve minimize cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;