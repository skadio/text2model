% Parameters
% Monetary amounts are in dollars.
int: total_budget = 50000;      % Maximum combined budget for X and Y
int: strategic_rhs = 10000;     % RHS of strategic constraint
int: cost_per_x = 5000;         % Cost per employee in group X
int: cost_per_y = 7000;         % Cost per employee in group Y
int: max_x = 40;                % Maximum employees trainable in group X
int: max_y = 20;                % Maximum employees trainable in group Y

% Variables
var 0..max_x: x;                % Number of employees trained in group X
var 0..max_y: y;                % Number of employees trained in group Y
var 0..total_budget: total_cost;% Total training cost (objective)

% Constraints
% Total cost definition (linking decision variables to monetary spend)
constraint
  total_cost = cost_per_x * x + cost_per_y * y;

% Budget feasibility: combined spend cannot exceed the available budget
constraint
  total_cost <= total_budget;

% Strategic allocation constraint:
% 3 * (allocation to group X) - (allocation to group Y) >= strategic_rhs
% where allocation to each group is (cost per employee) * (number of employees)
constraint
  3 * (cost_per_x * x) - (cost_per_y * y) >= strategic_rhs;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " total_cost=", show(total_cost), "\n"
];