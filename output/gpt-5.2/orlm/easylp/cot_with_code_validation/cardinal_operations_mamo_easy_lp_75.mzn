% Parameters
int: max_projects = 15;
int: min_strength = 10;
int: strength_x = 2;
int: strength_y = 3;
int: cost_x = 5;
int: cost_y = 3;

% Variables
var 0..max_projects: X;
var 0..max_projects: Y;
var 0..(cost_x * max_projects + cost_y * max_projects): total_support;

% Constraints
constraint X + Y <= max_projects;
constraint strength_x * X + strength_y * Y >= min_strength;
constraint total_support = cost_x * X + cost_y * Y;

% Objective
solve minimize total_support;