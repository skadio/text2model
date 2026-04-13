% Parameters
% Upper bounds (availability limits) for each unit type
int: max_x1 = 200;
int: max_x2 = 150;
int: max_x3 = 120;
int: max_x4 = 90;

% Costs per unit (supply points/unit)
int: cost_x1 = 5000;
int: cost_x2 = 4000;
int: cost_x3 = 6000;
int: cost_x4 = 7000;

% Constraint constants
int: min_x1_x2_sum = 100;    % X1 + X2 >= 100
int: cap_x2_x3 = 250;        % 2*X2 + 3*X3 <= 250
int: min_x4_minus_x1 = 50;   % X4 - X1 >= 50
int: max_x3_minus_2x4 = -30; % X3 - 2*X4 <= -30

% Variables
var 0..max_x1: x1; % number of units of type X1
var 0..max_x2: x2; % number of units of type X2
var 0..max_x3: x3; % number of units of type X3
var 0..max_x4: x4; % number of units of type X4

% Total cost (bounded for linear safety)
var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3 + cost_x4*max_x4): total_cost;

% Constraints
%--- Strategic/logistical feasibility constraints ---
% Minimum combined allocation for unit types X1 and X2
constraint x1 + x2 >= min_x1_x2_sum;

% Capacity limit relating unit types X2 and X3
constraint 2 * x2 + 3 * x3 <= cap_x2_x3;

% Minimum separation between X4 and X1 allocations
constraint x4 - x1 >= min_x4_minus_x1;

% Relationship constraint between X3 and X4 (X3 - 2*X4 <= -30)
constraint x3 - 2 * x4 <= max_x3_minus_2x4;

%--- Cost accounting constraint ---
% Define total cost from per-unit costs and chosen allocations
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;