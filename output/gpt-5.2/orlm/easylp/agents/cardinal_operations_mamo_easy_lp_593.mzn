% Parameters
% Unit costs per route
int: cost_x1 = 10;
int: cost_x2 = 20;
int: cost_x3 = 30;
int: cost_x4 = 40;

% Combined allocation limits
int: max_x1_x2 = 1000;   % x1 + x2 <= 1000 (vehicle availability)
int: max_x3_x4 = 2000;   % x3 + x4 <= 2000 (driver availability)

% Demand/relationship constraints
int: min_diff_x3_x1 = 500;  % x3 >= x1 + 500
int: min_diff_x4_x2 = 300;  % x4 >= x2 + 300

% Individual upper bounds
int: ub_x1 = 700;
int: ub_x2 = 800;
int: ub_x3 = 900;
int: ub_x4 = 1000;


% Variables
var 0..ub_x1: x1;  % resource allocated to route x1 (integer, non-negative)
var 0..ub_x2: x2;  % resource allocated to route x2 (integer, non-negative)
var 0..ub_x3: x3;  % resource allocated to route x3 (integer, non-negative)
var 0..ub_x4: x4;  % resource allocated to route x4 (integer, non-negative)

var int: total_cost; % total cost to minimize (integer due to integer costs/allocations)


% Constraints
%--- Total cost definition (linear expression) ---
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

%--- Combined allocation limits (resource availability) ---
constraint
  x1 + x2 <= max_x1_x2;  % Vehicle availability limit for routes x1 and x2

constraint
  x3 + x4 <= max_x3_x4;  % Driver availability limit for routes x3 and x4

%--- Demand/relationship constraints between routes ---
constraint
  x3 >= x1 + min_diff_x3_x1;  % Route x3 must exceed route x1 by at least 500

constraint
  x4 >= x2 + min_diff_x4_x2;  % Route x4 must exceed route x2 by at least 300


% Objective
solve minimize total_cost;