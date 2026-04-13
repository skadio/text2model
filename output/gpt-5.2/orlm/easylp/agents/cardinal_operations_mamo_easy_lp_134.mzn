% Parameters
int: cost_x = 100;                 % Cost per unit funding for project X (dollars)
int: cost_y = 200;                 % Cost per unit funding for project Y (dollars)
int: total_fund_max = 50;          % Maximum combined units of funding

int: eff_x_coeff = 3;              % Coefficient for X in effectiveness constraint
int: eff_y_coeff = -1;             % Coefficient for Y in effectiveness constraint (subtract Y)
int: eff_min = 10;                 % Minimum required effectiveness threshold

int: x_min = 0;                    % Minimum units for project X
int: x_max = 30;                   % Maximum units for project X
int: y_min = 0;                    % Minimum units for project Y
int: y_max = 20;                   % Maximum units for project Y

% Variables
var x_min..x_max: x;               % Integer units of funding allocated to project X
var y_min..y_max: y;               % Integer units of funding allocated to project Y
var 0..(cost_x * x_max + cost_y * y_max): total_cost;  % Total cost in dollars (bounded)

% Constraints
% Budget constraint: total funded units across both projects cannot exceed the maximum
constraint
  x + y <= total_fund_max;

% Effectiveness constraint: ensure minimum combined effectiveness threshold is met
constraint
  eff_x_coeff * x + eff_y_coeff * y >= eff_min;

% Total cost definition: compute total_cost from per-unit costs and allocations
constraint
  total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;