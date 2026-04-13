% Parameters
int: max_total_projects = 50;
int: min_diversity = 30;               % 2*X + Y >= 30
int: max_diff = 10;                    % |X - Y| <= 10

int: max_X = 40;
int: max_Y = 20;

int: cost_X = 2000;
int: cost_Y = 3000;

% Variables
var 0..max_X: X;
var 0..max_Y: Y;
var 0..(cost_X*max_X + cost_Y*max_Y): total_cost;

% Constraints
constraint X + Y <= max_total_projects;
constraint 2 * X + Y >= min_diversity;
constraint abs(X - Y) <= max_diff;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;