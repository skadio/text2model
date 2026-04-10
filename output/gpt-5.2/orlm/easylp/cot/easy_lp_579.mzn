% Parameters (with values embedded)
int: max_projects = 50;
int: min_residential = 10;
int: min_commercial  = 15;
int: min_industrial  = 5;

int: cost_residential = 10000;
int: cost_commercial  = 8000;
int: cost_industrial  = 6000;

int: portfolio_min = 20;

% Variables
var 0..max_projects: X; % Residential projects
var 0..max_projects: Y; % Commercial projects
var 0..max_projects: Z; % Industrial projects

% Constraints
constraint X + Y + Z <= max_projects;

constraint X >= min_residential;
constraint Y >= min_commercial;
constraint Z >= min_industrial;

constraint 2*X - Y + Z >= portfolio_min;

% Objective
var int: total_cost = cost_residential*X + cost_commercial*Y + cost_industrial*Z;
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];