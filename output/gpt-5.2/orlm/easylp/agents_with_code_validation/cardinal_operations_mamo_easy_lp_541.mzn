% Parameters
% Unit costs per resource unit allocated to each project
int: cost_x1 = 500;
int: cost_x2 = 600;
int: cost_x3 = 700;

% Total available resource units
int: total_resource_max = 1000;

% Constraint thresholds
int: min_expr_x1_x2 = 200;   % for (2*x1 - 0.5*x2) >= 200
int: max_expr_x3_x1 = 300;   % for (2*x3 - x1) <= 300


% Variables
% Resource allocations (whole numbers, non-negative, and bounded by total availability)
var 0..total_resource_max: x1; % allocation to project X1
var 0..total_resource_max: x2; % allocation to project X2
var 0..total_resource_max: x3; % allocation to project X3

% Auxiliary variable to keep all linear integer arithmetic (since 0.5*x2 appears)
% Represents y2 = x2/2, enforced via x2 = 2*y2.
var 0..total_resource_max: y2;

% Objective value (total cost), bounded by worst-case max allocation
var 0..(total_resource_max * max([cost_x1, cost_x2, cost_x3])): total_cost;


% Constraints
% --- Resource capacity constraint ---
constraint x1 + x2 + x3 <= total_resource_max;

% --- Link auxiliary variable y2 to x2 to model 0.5*x2 using integer arithmetic ---
constraint x2 = 2 * y2;

% --- Requirement constraint between X1 and X2 ---
% (2*x1 - 0.5*x2) >= 200  becomes  (2*x1 - y2) >= 200 using y2 = x2/2.
constraint 2 * x1 - y2 >= min_expr_x1_x2;

% --- Balance constraint between X3 and X1 ---
constraint 2 * x3 - x1 <= max_expr_x3_x1;

% --- Define total cost ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;


% Objective
solve minimize total_cost;

% Optional output for inspection
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " (y2=", show(y2), ")\n",
  "total_cost=", show(total_cost), "\n"
];