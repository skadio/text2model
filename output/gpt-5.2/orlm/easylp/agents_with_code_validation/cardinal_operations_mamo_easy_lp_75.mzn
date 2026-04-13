% Parameters
int: max_projects = 15;              % Maximum total number of projects X+Y
int: req_x_coeff = 2;                % Coefficient of X in strategic constraint
int: req_y_coeff = 3;                % Coefficient of Y in strategic constraint
int: req_min_strength = 10;          % Minimum required combined strength
int: support_per_x = 5;              % Support points per unit of project X
int: support_per_y = 3;              % Support points per unit of project Y

% Variables
var 0..max_projects: x;              % Integer units of project X
var 0..max_projects: y;              % Integer units of project Y
var 0..(support_per_x*max_projects + support_per_y*max_projects): total_support;
                                      % Total support points (objective)

% Constraints
% Link total_support to the chosen numbers of projects
constraint total_support = support_per_x * x + support_per_y * y;

% Logistical capacity: total projects cannot exceed the maximum supported
constraint x + y <= max_projects;

% Strategic requirement: combined strength must meet or exceed the minimum
constraint req_x_coeff * x + req_y_coeff * y >= req_min_strength;

% Objective
solve minimize total_support;