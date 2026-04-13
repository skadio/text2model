% Parameters
% Unit costs ($ per unit) for each project
int: cost_x1 = 50;
int: cost_x2 = 60;
int: cost_x3 = 30;
int: cost_x4 = 40;

% Budget/relationship limits
int: max_x1_x2_sum = 5000;     % x1 + x2 <= 5000
int: max_x3_x4_sum = 2000;     % x3 + x4 <= 2000
int: min_x1_x2_diff = 1000;    % x1 - x2 >= 1000 (at least 1000)
int: max_x3_x4_diff = 500;     % x3 - x4 <= 500  (not exceed 500)

% Individual bounds
int: x1_lb = 0;   int: x1_ub = 3000;
int: x2_lb = 0;   int: x2_ub = 2500;
int: x3_lb = 0;   int: x3_ub = 1500;
int: x4_lb = 0;   int: x4_ub = 1200;


% Variables
var x1_lb..x1_ub: x1;  % allocation for project x1 (integer units)
var x2_lb..x2_ub: x2;  % allocation for project x2 (integer units)
var x3_lb..x3_ub: x3;  % allocation for project x3 (integer units)
var x4_lb..x4_ub: x4;  % allocation for project x4 (integer units)

% Total cost (bounded above by maximum possible cost under individual bounds)
var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub + cost_x4*x4_ub): total_cost;


% Constraints
% --- Define total cost from unit costs and allocations ---
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% --- Budget/combined allocation limits ---
constraint
  x1 + x2 <= max_x1_x2_sum;

constraint
  x3 + x4 <= max_x3_x4_sum;

% --- Difference/relationship constraints between allocations ---
constraint
  x1 - x2 >= min_x1_x2_diff;

constraint
  x3 - x4 <= max_x3_x4_diff;


% Objective
solve minimize total_cost;