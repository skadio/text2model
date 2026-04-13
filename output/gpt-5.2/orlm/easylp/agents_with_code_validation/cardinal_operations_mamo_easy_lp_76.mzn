% Parameters
int: max_total_projects = 50;          % Upper bound on total number of projects X+Y
int: min_diversity = 30;              % Minimum required value for 2*X + Y
int: max_difference = 10;             % Maximum allowed absolute difference |X - Y|
int: max_x_projects = 40;             % Maximum number of X projects
int: max_y_projects = 20;             % Maximum number of Y projects
int: cost_x = 2000;                   % Cost per X project (dollars)
int: cost_y = 3000;                   % Cost per Y project (dollars)

% Variables
var 0..max_x_projects: x_projects;     % Number of X projects (integer)
var 0..max_y_projects: y_projects;     % Number of Y projects (integer)
var 0..(max_x_projects * cost_x + max_y_projects * cost_y): total_cost; % Total cost (dollars)

% Constraints
% Capacity constraint: total number of projects cannot exceed the overall limit
constraint x_projects + y_projects <= max_total_projects;

% Diversity constraint: ensure sufficient weighted mix of project types
constraint 2 * x_projects + y_projects >= min_diversity;

% Balance constraint: keep the portfolio balanced between X and Y
constraint abs(x_projects - y_projects) <= max_difference;

% Cost definition: compute total cost from chosen numbers of projects
constraint total_cost = cost_x * x_projects + cost_y * y_projects;

% Objective
solve minimize total_cost;