% Parameters
int: max_projects = 15;
int: min_strength = 10;
int: strength_X = 2;
int: strength_Y = 3;
int: cost_X = 5;
int: cost_Y = 3;

% Variables
var 0..max_projects: X;
var 0..max_projects: Y;
var 0..(cost_X * max_projects + cost_Y * max_projects): total_support;

% Constraints
constraint X + Y <= max_projects;
constraint strength_X * X + strength_Y * Y >= min_strength;
constraint total_support = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_support;