% Parameters
% Costs per unit allocation
int: cost_x1 = 5000;
int: cost_x2 = 3000;
int: cost_x3 = 4000;
int: cost_x4 = 2000;

% Total allocation limit
int: total_limit = 10000;

% Bounds on allocations (inclusive)
int: x1_lb = 0;   int: x1_ub = 3000;
int: x2_lb = 0;   int: x2_ub = 2500;
int: x3_lb = 0;   int: x3_ub = 1500;
int: x4_lb = 0;   int: x4_ub = 300;

% (Optional) scaling constants retained for clarity (not strictly required)
int: two = 2;
int: ten = 10;

% Variables
% Integer allocations to each unit (whole numbers)
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

% Total cost (integer dollars/units)
var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub + cost_x4*x4_ub): total_cost;

% Constraints
% --- Total allocation limit (overall operational cap) ---
constraint
  x1 + x2 + x3 + x4 <= total_limit;

% --- Relative allocation constraints (scaled to avoid floats) ---

% 5*x1 >= 2000 + 3.5*x2  -> multiply by 2: 10*x1 >= 4000 + 7*x2
constraint
  10 * x1 >= 4000 + 7 * x2;

% 4.7*x4 <= x3 + 3500 -> multiply by 10: 47*x4 <= 10*x3 + 35000
constraint
  47 * x4 <= 10 * x3 + 35000;

% x2 + 3.5*x3 + x4 - 2.5*x1 >= 1000
% -> multiply by 2: 2*x2 + 7*x3 + 2*x4 - 5*x1 >= 2000
constraint
  2 * x2 + 7 * x3 + 2 * x4 - 5 * x1 >= 2000;

% --- Total cost definition (linking variable to allocations) ---
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;