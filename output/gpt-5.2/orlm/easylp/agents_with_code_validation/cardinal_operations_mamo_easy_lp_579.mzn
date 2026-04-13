% Parameters
int: max_projects = 50;                 % Capacity limit on total number of projects

int: min_residential = 10;              % Minimum required residential projects (X)
int: min_commercial  = 15;              % Minimum required commercial projects (Y)
int: min_industrial  = 5;               % Minimum required industrial projects (Z)

int: portfolio_min = 20;                % Minimum required value for (2X - Y + Z)

int: cost_residential = 10000;          % Cost per residential project
int: cost_commercial  = 8000;           % Cost per commercial project
int: cost_industrial  = 6000;           % Cost per industrial project

% Variables
var 0..max_projects: X;                 % Number of residential projects
var 0..max_projects: Y;                 % Number of commercial projects
var 0..max_projects: Z;                 % Number of industrial projects

% Upper bound: max_projects * max(unit costs)
var 0..(max_projects * max(cost_residential, max(cost_commercial, cost_industrial))):
    total_cost;                         % Total cost in dollars

% Constraints

% --- Capacity constraint: total number of projects cannot exceed the maximum ---
constraint
    X + Y + Z <= max_projects;

% --- Minimum demand constraints for each project type ---
constraint X >= min_residential;
constraint Y >= min_commercial;
constraint Z >= min_industrial;

% --- Portfolio balance constraint: ensure (2X - Y + Z) meets minimum threshold ---
constraint
    2 * X - Y + Z >= portfolio_min;

% --- Total cost definition constraint (ensures consistency with chosen project counts) ---
constraint
    total_cost =
        cost_residential * X +
        cost_commercial  * Y +
        cost_industrial  * Z;

% Objective
solve minimize total_cost;