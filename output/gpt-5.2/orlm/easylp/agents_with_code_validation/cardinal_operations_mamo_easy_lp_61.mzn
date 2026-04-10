% Parameters
% Coefficients for effort/quality constraints
int: effort_x = 5;
int: effort_y = 10;
int: min_effort = 50;

int: qual_x = 3;
int: qual_y = 4;
int: max_qual = 36;

% Unit costs (dollars per resource unit)
int: cost_x = 20;
int: cost_y = 30;

% Safe upper bounds derived from 3x + 4y <= 36
int: x_ub = max_qual div qual_x; % 12
int: y_ub = max_qual div qual_y; % 9

% Variables
var 0..x_ub: x; % integer resources allocated to Task X
var 0..y_ub: y; % integer resources allocated to Task Y

% Total cost (bounded using variable upper bounds)
var 0..(cost_x * x_ub + cost_y * y_ub): total_cost;

% Constraints
% Effort requirement
constraint effort_x * x + effort_y * y >= min_effort;

% Quality/combined-effort cap
constraint qual_x * x + qual_y * y <= max_qual;

% Define total cost
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;