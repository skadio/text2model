% Parameters (with values embedded)
int: max_projects = 15;
int: req_strength = 10;
int: strength_X = 2;
int: strength_Y = 3;
int: support_X = 5;
int: support_Y = 3;

% Variables
var 0..max_projects: X;
var 0..max_projects: Y;
var 0..(support_X*max_projects + support_Y*max_projects): total_support;

% Constraints
constraint X + Y <= max_projects;
constraint strength_X * X + strength_Y * Y >= req_strength;
constraint total_support = support_X * X + support_Y * Y;

% Objective
solve minimize total_support;