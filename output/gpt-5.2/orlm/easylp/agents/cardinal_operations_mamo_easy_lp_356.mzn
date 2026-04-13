% Parameters
% Cost coefficients for each product category
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Constraint right-hand sides
int: max_x1_plus_x2 = 100;        % x1 + x2 <= 100
int: min_2x1_plus_x3 = 50;        % 2*x1 + x3 >= 50
int: max_x2_minus_3x4 = 20;       % x2 - 3*x4 <= 20
int: min_x4_minus_half_x1 = 10;   % x4 - 0.5*x1 >= 10


% Variables
% Integer allocations for each category (non-negative, whole units)
var 0..1000: x1; % clothing
var 0..1000: x2; % electronics
var 0..1000: x3; % groceries
var 0..1000: x4; % home appliances

% Total cost to minimize
var 0..(c1*1000 + c2*1000 + c3*1000 + c4*1000): total_cost;


% Constraints
% Budget/storage limit: clothing + electronics cannot exceed the maximum
constraint x1 + x2 <= max_x1_plus_x2;

% Minimum combined allocation: twice clothing plus groceries must reach at least the minimum
constraint 2 * x1 + x3 >= min_2x1_plus_x3;

% Relationship limit: electronics minus three times home appliances cannot exceed the maximum
constraint x2 - 3 * x4 <= max_x2_minus_3x4;

% Fractional constraint rewritten to keep integrality:
% x4 - 0.5*x1 >= 10  <=>  2*x4 - x1 >= 20
constraint 2 * x4 - x1 >= 2 * min_x4_minus_half_x1;

% Total cost definition
constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;


% Objective
solve minimize total_cost;