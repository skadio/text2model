% Parameters
% Budget limit (in dollars)
int: budget = 10000;

% Unit costs per dollar invested in each option (in dollars per unit of investment)
int: cost1 = 500;
int: cost2 = 400;
int: cost3 = 300;

% Constraint constants
int: min_tradeoff = 2000;     % for 0.5*x1 - 0.25*x2 >= 2000
int: max_balance_diff = 500;  % for x3 - x1 <= 500


% Variables
% Amount invested in each option (whole dollars, nonnegative, bounded by budget)
var 0..budget: x1;
var 0..budget: x2;
var 0..budget: x3;

% Total cost to minimize (bounded using max unit cost * budget)
var 0..(max([cost1, cost2, cost3]) * budget): total_cost;


% Constraints
% Budget constraint: total investment cannot exceed available budget
constraint x1 + x2 + x3 <= budget;

% Trade-off constraint: 0.5*x1 - 0.25*x2 >= 2000
% Multiply by 4 to avoid fractions and keep integer arithmetic: 2*x1 - x2 >= 8000
constraint 2 * x1 - x2 >= 4 * min_tradeoff;

% Balance constraint: x3 - x1 <= 500
constraint x3 - x1 <= max_balance_diff;

% Total cost definition
constraint total_cost = cost1 * x1 + cost2 * x2 + cost3 * x3;


% Objective
solve minimize total_cost;