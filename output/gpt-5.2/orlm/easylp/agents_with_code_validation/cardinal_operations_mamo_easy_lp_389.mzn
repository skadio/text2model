% Parameters
% Costs per unit allocation for each tour
int: cost_x1 = 100;
int: cost_x2 = 200;
int: cost_x3 = 300;
int: cost_x4 = 400;

% Capacity / combined upper bounds
int: max_x1_plus_x2 = 500;
int: max_x3_plus_x4 = 600;

% Minimum combined allocation requirements
int: min_x1_plus_x3 = 300;
int: min_x2_plus_x4 = 400;

% Individual upper bounds
int: ub_x1 = 500;
int: ub_x2 = 500;
int: ub_x3 = 600;
int: ub_x4 = 600;

% Variables
% Integer allocations (whole numbers), nonnegative with given upper bounds
var 0..ub_x1: x1;  % allocation for tour 1
var 0..ub_x2: x2;  % allocation for tour 2
var 0..ub_x3: x3;  % allocation for tour 3
var 0..ub_x4: x4;  % allocation for tour 4

% Total cost (bounded using max individual upper bounds)
var 0..(cost_x1*ub_x1 + cost_x2*ub_x2 + cost_x3*ub_x3 + cost_x4*ub_x4): total_cost;

% Constraints
% --- Total cost definition ---
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% --- Combined upper-bound (budget/capacity) constraints ---
constraint x1 + x2 <= max_x1_plus_x2;
constraint x3 + x4 <= max_x3_plus_x4;

% --- Minimum combined allocation (demand/diversity) constraints ---
constraint x1 + x3 >= min_x1_plus_x3;
constraint x2 + x4 >= min_x2_plus_x4;

% Objective
solve minimize total_cost;

% (Optional) Output for inspection
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];