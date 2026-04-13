% Parameters
% Budget limit across all projects
int: total_budget = 5000;

% Minimum gap requirements
int: min_gap_x_vs_2y = 1000;   % X >= 2*Y + 1000
int: min_gap_z_vs_y  = 1500;   % Z >= Y + 1500

% Per-dollar cost coefficients
int: cost_x = 10;
int: cost_y = 15;
int: cost_z = 20;

% Variables
% Dollar allocations (must be whole dollars and non-negative)
var 0..total_budget: x;  % allocation to project X
var 0..total_budget: y;  % allocation to project Y
var 0..total_budget: z;  % allocation to project Z

% Total cost to minimize (upper bound for safety)
var 0..(cost_x + cost_y + cost_z) * total_budget: total_cost;

% Constraints

% --- Budget feasibility constraints ---
constraint
  % Total allocated dollars cannot exceed the available budget
  x + y + z <= total_budget;

% --- Minimum gap / dominance constraints ---
constraint
  % Project X must exceed twice project Y by at least the specified gap
  x >= 2 * y + min_gap_x_vs_2y;

constraint
  % Project Z must exceed project Y by at least the specified gap
  z >= y + min_gap_z_vs_y;

% --- Cost definition constraint ---
constraint
  % Total cost incurred by the allocations (linear cost model)
  total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;