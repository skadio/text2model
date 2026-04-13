% Parameters
int: max_projects = 50;

int: min_res = 10;
int: min_com = 15;
int: min_ind = 5;

int: cost_res = 10000;
int: cost_com = 8000;
int: cost_ind = 6000;

int: balance_rhs = 20;

% Variables
var min_res..max_projects: X; % Residential
var min_com..max_projects: Y; % Commercial
var min_ind..max_projects: Z; % Industrial

var 0..(max_projects * max([cost_res, cost_com, cost_ind])): total_cost;

% Constraints
constraint X + Y + Z <= max_projects;

constraint 2 * X - Y + Z >= balance_rhs;

constraint total_cost = cost_res * X + cost_com * Y + cost_ind * Z;

% Objective
solve minimize total_cost;