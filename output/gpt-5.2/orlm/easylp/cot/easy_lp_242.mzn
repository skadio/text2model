% Parameters (with values embedded)
int: max_projects = 50;
int: min_effectiveness = 150;
int: max_diff_xy = 10;

int: costX = 2000;
int: costY = 3000;
int: costZ = 4000;

% Variables
var 0..max_projects: X;
var 0..max_projects: Y;
var 0..max_projects: Z;

var 0..(costX*max_projects + costY*max_projects + costZ*max_projects): total_cost;

% Constraints
constraint X + Y + Z <= max_projects;

constraint 3*X + 4*Y + 5*Z >= min_effectiveness;

constraint abs(X - Y) <= max_diff_xy;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;