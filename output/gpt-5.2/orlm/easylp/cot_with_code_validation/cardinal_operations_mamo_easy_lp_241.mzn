% Parameters
int: max_projects = 20;
int: min_diversity = 5;              % X + 0.5*Y >= 5  ->  2X + Y >= 10
int: max_expertise = 10;             % Y + Z <= 10

int: costX = 1000;
int: costY = 2000;
int: costZ = 1500;

% Variables
var 0..max_projects: X;
var 0..max_projects: Y;
var 0..max_projects: Z;

var 0..(costX*max_projects + costY*max_projects + costZ*max_projects): total_cost;

% Constraints
constraint X + Y + Z <= max_projects;
constraint 2*X + Y >= 2*min_diversity;
constraint Y + Z <= max_expertise;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;