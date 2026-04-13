% Parameters
int: total_budget = 5000;            % Maximum total resource allocation across projects
int: min_invest_x = 1000;            % Minimum viable investment in project X
int: min_invest_y = 1500;            % Minimum viable investment in project Y
int: cost_per_unit_x = 100;          % Cost per unit invested in project X (in dollars)
int: cost_per_unit_y = 75;           % Cost per unit invested in project Y (in dollars)

% Variables
var 0..total_budget: x_units;        % Integer units allocated to project X
var 0..total_budget: y_units;        % Integer units allocated to project Y
var 0..(cost_per_unit_x * total_budget + cost_per_unit_y * total_budget): total_cost; % Total cost (in dollars)

% Constraints
% Budget feasibility: total allocated units across both projects must not exceed available budget
constraint x_units + y_units <= total_budget;

% Minimum viable investment levels for each project
constraint x_units >= min_invest_x;
constraint y_units >= min_invest_y;

% Total cost definition: linear cost accumulation from both projects
constraint total_cost = cost_per_unit_x * x_units + cost_per_unit_y * y_units;

% Objective
solve minimize total_cost;