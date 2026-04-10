% Parameters
int: max_residential = 15;          % Maximum number of residential buildings allowed
int: max_commercial  = 10;          % Maximum number of commercial buildings allowed
int: max_total       = 20;          % Maximum total buildings due to land limit

int: min_effort_scaled = 30;        % Scaled minimum effort: 2*x + 0.5*y >= 15  => 4*x + y >= 30
int: max_diff          = 5;         % Maximum allowed absolute difference |x - y|

int: cost_residential = 30000;      % Cost per residential building (USD)
int: cost_commercial  = 50000;      % Cost per commercial building (USD)

% Variables
var 0..max_residential: x;          % Number of residential buildings (integer, bounded)
var 0..max_commercial:  y;          % Number of commercial buildings (integer, bounded)

var 0..(max_residential*cost_residential + max_commercial*cost_commercial): total_cost;
                                    % Total construction cost (USD, bounded)

% Constraints
% Link total cost to decision variables (cost accounting)
constraint
  total_cost = x * cost_residential + y * cost_commercial;

% Land use / total building count limit
constraint
  x + y <= max_total;

% Minimum combined effort requirement (scaled to avoid fractions): 4*x + y >= 30
constraint
  4 * x + y >= min_effort_scaled;

% Aesthetic balance: absolute difference between residential and commercial counts
constraint
  abs(x - y) <= max_diff;

% Objective
solve minimize total_cost;