include "globals.mzn";

% Embedded data from the description
int: max_projects = 15;
int: min_strength = 10;

int: strengthX = 2;
int: strengthY = 3;

int: costX = 5;
int: costY = 3;

% Decision variables: number of units of project X and Y (integers)
var 0..max_projects: X;
var 0..max_projects: Y;

% Constraints
constraint X + Y <= max_projects;
constraint strengthX * X + strengthY * Y >= min_strength;

% Objective: minimize total support points
var 0..(max_projects * max(costX, costY)): total_support;
constraint total_support = costX * X + costY * Y;

solve minimize total_support;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total support points = ", show(total_support), "\n"
];