% Parameters
int: max_projects = 50;
int: min_residential = 10;
int: min_commercial = 15;
int: min_industrial = 5;
int: balance_min = 20;

int: cost_residential = 10000;
int: cost_commercial  = 8000;
int: cost_industrial  = 6000;

% Variables
var min_residential..max_projects: X; % Residential projects
var min_commercial..max_projects: Y;  % Commercial projects
var min_industrial..max_projects: Z;  % Industrial projects

var 0..(max_projects * max(cost_residential, max(cost_commercial, cost_industrial))): total_cost;

% Constraints
constraint X + Y + Z <= max_projects;

constraint 2*X - Y + Z >= balance_min;

constraint total_cost = cost_residential * X + cost_commercial * Y + cost_industrial * Z;

% Objective
solve minimize total_cost;