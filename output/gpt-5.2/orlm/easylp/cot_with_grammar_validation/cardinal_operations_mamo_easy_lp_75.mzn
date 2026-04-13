% Parameters
int: max_projects = 15;
int: req_strength = 10;
int: aX = 2;
int: aY = 3;
int: costX = 5;
int: costY = 3;

% Variables
var 0..max_projects: X;
var 0..max_projects: Y;
var 0..(costX*max_projects + costY*max_projects): total_support;

% Constraints
constraint X + Y <= max_projects;
constraint aX * X + aY * Y >= req_strength;
constraint total_support = costX * X + costY * Y;

% Objective
solve minimize total_support;