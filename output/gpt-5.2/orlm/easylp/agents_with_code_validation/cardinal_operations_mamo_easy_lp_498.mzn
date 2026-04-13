% Parameters
int: max_residential = 15;           % Maximum number of residential buildings (x)
int: max_commercial  = 10;           % Maximum number of commercial buildings (y)
int: max_total       = 20;           % Maximum total buildings (x + y)

int: min_effort      = 15;           % Minimum required effort level
int: max_diff        = 5;            % Maximum allowed absolute difference |x - y|

int: cost_residential = 30000;       % Cost per residential building
int: cost_commercial  = 50000;       % Cost per commercial building

% Variables
var 0..max_residential: x;           % Number of residential buildings
var 0..max_commercial:  y;           % Number of commercial buildings
var 0..(max_residential*cost_residential + max_commercial*cost_commercial): total_cost;

% Constraints
% Total buildings cannot exceed available land capacity
constraint x + y <= max_total;

% Minimum required combined effort: 2*x + 0.5*y >= min_effort
% Integer-safe form (multiply by 2): 4*x + y >= 2*min_effort
constraint 4 * x + y >= 2 * min_effort;

% Aesthetic balance: absolute difference between residential and commercial buildings
constraint abs(x - y) <= max_diff;

% Define total construction cost from decision variables
constraint total_cost = x * cost_residential + y * cost_commercial;

% Objective
solve minimize total_cost;