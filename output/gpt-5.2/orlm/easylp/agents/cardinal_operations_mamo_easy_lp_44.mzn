% Parameters
int: max_total_resources = 100;      % Maximum combined allocation (X + Y)
int: min_effectiveness = 20;         % Minimum required effectiveness (X + Y)
int: cost_x = 2;                     % Cost per unit for department X
int: cost_y = 3;                     % Cost per unit for department Y

% Variables
var 0..max_total_resources: x;       % Integer allocation to emergency department X
var 0..max_total_resources: y;       % Integer allocation to surgery department Y
var 0..(cost_x*max_total_resources + cost_y*max_total_resources): total_cost; % Total resource usage to minimize

% Constraints
% Total allocation budget constraint (X + Y cannot exceed maximum)
constraint x + y <= max_total_resources;

% Minimum effectiveness requirement (effectiveness = X + Y)
constraint x + y >= min_effectiveness;

% Define total resource usage (cost-weighted total)
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;