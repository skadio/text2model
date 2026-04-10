% Parameters
% Budget limit (maximum total dollars invested across all options)
int: budget = 10000;

% Unit costs (dollars per unit) for investments x1, x2, x3
int: cost_x1 = 500;
int: cost_x2 = 400;
int: cost_x3 = 300;

% Constraint parameters for: (1/2)x1 - (1/4)x2 >= 2000
int: min_tradeoff = 2000;

% Constraint parameter for: x3 - x1 <= 500
int: max_diff_x3_x1 = 500;


% Variables
% Amount (whole dollars) allocated to each investment option
var 0..budget: x1;  % dollars in option 1
var 0..budget: x2;  % dollars in option 2
var 0..budget: x3;  % dollars in option 3

% Total cost to minimize (in dollars)
var 0..(cost_x1*budget + cost_x2*budget + cost_x3*budget): total_cost;


% Constraints
% Budget constraint: total dollars allocated cannot exceed available budget
constraint x1 + x2 + x3 <= budget;

% Trade-off constraint: (1/2)x1 - (1/4)x2 >= min_tradeoff
% Multiply by 4 to avoid fractional coefficients and ensure integer arithmetic
constraint 2 * x1 - x2 >= 4 * min_tradeoff;

% Balance constraint between x3 and x1: x3 - x1 <= max_diff_x3_x1
constraint x3 - x1 <= max_diff_x3_x1;

% Total cost definition (linear expression in dollars)
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;


% Objective
solve minimize total_cost;