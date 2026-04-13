% Parameters
int: max_projects = 50;
int: min_residential = 10;
int: min_commercial  = 15;
int: min_industrial  = 5;
int: balance_min = 20;

int: cost_residential = 10000;
int: cost_commercial  = 8000;
int: cost_industrial  = 6000;

% Variables
var 0..max_projects: X; % Residential
var 0..max_projects: Y; % Commercial
var 0..max_projects: Z; % Industrial

var int: total_cost;

% Constraints
constraint X >= min_residential;
constraint Y >= min_commercial;
constraint Z >= min_industrial;

constraint X + Y + Z <= max_projects;

constraint 2*X - Y + Z >= balance_min;

constraint total_cost = cost_residential*X + cost_commercial*Y + cost_industrial*Z;

% Objective
solve minimize total_cost;