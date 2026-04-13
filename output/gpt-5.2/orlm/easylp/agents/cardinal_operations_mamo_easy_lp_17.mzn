% Parameters
int: min_total_investment = 30;      % Minimum total investment across X and Y
int: max_total_resource = 150;       % Maximum allowed combined resource usage

int: resource_per_x = 5;             % Resource usage per unit investment in project X
int: resource_per_y = 3;             % Resource usage per unit investment in project Y

int: cost_per_x = 40;                % Cost per unit investment in project X
int: cost_per_y = 50;                % Cost per unit investment in project Y

% Variables
var 0..(max_total_resource div resource_per_x): x;   % Integer investment in project X
var 0..(max_total_resource div resource_per_y): y;   % Integer investment in project Y

% Upper bound is a safe bound based on max possible x and y from the resource cap
var 0..(cost_per_x * (max_total_resource div resource_per_x)
      + cost_per_y * (max_total_resource div resource_per_y)): total_cost;  % Total cost to minimize

% Constraints
% Minimum total investment requirement
constraint x + y >= min_total_investment;

% Sustainability / resource usage cap
constraint resource_per_x * x + resource_per_y * y <= max_total_resource;

% Define total cost from investments
constraint total_cost = cost_per_x * x + cost_per_y * y;

% Objective
solve minimize total_cost;