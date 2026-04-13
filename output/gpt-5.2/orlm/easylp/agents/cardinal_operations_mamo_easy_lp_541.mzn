% Parameters
% Unit costs ($ per resource unit) for each project
int: cost_x1 = 500;
int: cost_x2 = 600;
int: cost_x3 = 700;

% Total resource capacity (units)
int: total_resource_cap = 1000;

% Constraint thresholds
int: min_priority_gap = 200;     % 2*x1 - 0.5*x2 >= 200  (implemented without fractions)
int: max_balance_gap  = 300;     % 2*x3 - x1 <= 300

% Explicit bounds for decision variables (non-negative allocations)
int: lb_alloc = 0;
int: ub_alloc = total_resource_cap;


% Variables
% Integer resource allocation to each project (units)
var lb_alloc..ub_alloc: x1;
var lb_alloc..ub_alloc: x2;
var lb_alloc..ub_alloc: x3;

% Total cost (upper bound uses the highest unit cost times max total units)
var 0..(cost_x3 * total_resource_cap): total_cost;


% Constraints
% Resource capacity: total allocation across all projects cannot exceed capacity
constraint
  x1 + x2 + x3 <= total_resource_cap;

% Priority gap requirement:
% 2*x1 - 0.5*x2 >= min_priority_gap
% Multiply by 2 to avoid fractions: 4*x1 - x2 >= 2*min_priority_gap
constraint
  4 * x1 - x2 >= 2 * min_priority_gap;

% Balance requirement between projects X3 and X1:
% 2*x3 - x1 <= max_balance_gap
constraint
  2 * x3 - x1 <= max_balance_gap;

% Total cost definition
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;


% Objective
solve minimize total_cost;