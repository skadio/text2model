% Parameters
int: max_projects = 50;                 % Capacity limit on total number of projects

int: min_residential = 10;              % Minimum required residential projects
int: min_commercial  = 15;              % Minimum required commercial projects
int: min_industrial  = 5;               % Minimum required industrial projects

int: portfolio_min = 20;                % Minimum required value of (2X - Y + Z)

int: cost_residential = 10000;          % Cost per residential project ($)
int: cost_commercial  = 8000;           % Cost per commercial project ($)
int: cost_industrial  = 6000;           % Cost per industrial project ($)

% Variables
var 0..max_projects: X;                 % Number of residential projects
var 0..max_projects: Y;                 % Number of commercial projects
var 0..max_projects: Z;                 % Number of industrial projects

var 0..(max_projects * max([cost_residential, cost_commercial, cost_industrial])): total_cost;
                                        % Total cost ($), bounded by max_projects * max unit cost

% Constraints

% Capacity constraint: total number of projects cannot exceed capacity
constraint X + Y + Z <= max_projects;

% Minimum project requirements: meet market demand thresholds
constraint X >= min_residential;
constraint Y >= min_commercial;
constraint Z >= min_industrial;

% Portfolio balance constraint: ensure balanced mix (2X - Y + Z) meets minimum
constraint 2 * X - Y + Z >= portfolio_min;

% Total cost definition: link total_cost to decision variables and unit costs
constraint total_cost = cost_residential * X + cost_commercial * Y + cost_industrial * Z;

% Objective
solve minimize total_cost;