% Parameters
int: costX = 5000;
int: costY = 7000;

int: minX = 0;
int: maxX = 5;
int: minY = 0;
int: maxY = 4;

int: strengthX = 2;
int: strengthY = 3;
int: minStrength = 10;

int: maxProjects = 8;

% Variables
var minX..maxX: X;
var minY..maxY: Y;

var 0..(costX * maxX + costY * maxY): total_cost;

% Constraints
constraint strengthX * X + strengthY * Y >= minStrength;

constraint X + Y <= maxProjects;

constraint Y >= X + 1;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;