% Parameters
int: cost_X = 500;                 % Cost per unit resource allocated to Project X
int: cost_Y = 700;                 % Cost per unit resource allocated to Project Y

int: effort_coeff_X = 2;           % Effort contribution coefficient for Project X
int: effort_coeff_Y = 3;           % Effort contribution coefficient for Project Y
int: min_total_effort = 2000;      % Minimum required combined effort

int: max_total_resources = 1500;   % Maximum total resources available (budget constraint)

% Variables
var 0..max_total_resources: x;     % Whole units of resources allocated to Project X
var 0..max_total_resources: y;     % Whole units of resources allocated to Project Y
var int: total_cost;               % Total cost to minimize

% Constraints
% ---- Total cost definition ----
constraint
  total_cost = cost_X * x + cost_Y * y;

% ---- Minimum combined effort requirement ----
constraint
  effort_coeff_X * x + effort_coeff_Y * y >= min_total_effort;

% ---- Total resource (budget) limit ----
constraint
  x + y <= max_total_resources;

% Objective
solve minimize total_cost;