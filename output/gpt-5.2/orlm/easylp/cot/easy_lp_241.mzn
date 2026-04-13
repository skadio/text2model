% Parameters (with values embedded)
int: max_total_projects = 20;
int: min_diversity_req = 5;          % X + 0.5*Y >= 5
int: max_expertise_cap = 10;         % Y + Z <= 10

int: cost_X = 1000;
int: cost_Y = 2000;
int: cost_Z = 1500;

% Variables
var 0..max_total_projects: X;
var 0..max_total_projects: Y;
var 0..max_total_projects: Z;

var 0..(max_total_projects * max(cost_X, max(cost_Y, cost_Z))): total_cost;

% Constraints
constraint X + Y + Z <= max_total_projects;

% Avoid fractions by multiplying by 2: 2*X + Y >= 10
constraint 2*X + Y >= 2*min_diversity_req;

constraint Y + Z <= max_expertise_cap;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;