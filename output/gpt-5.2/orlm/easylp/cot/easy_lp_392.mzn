% Parameters (with values embedded)
int: nSchools = 4;
set of int: Schools = 1..nSchools;

int: X = 1;
int: Y = 2;
int: Z = 3;
int: W = 4;

array[Schools] of int: cost = [2, 3, 4, 5];

% Upper bounds (chosen sufficiently large to cover all feasible optima)
int: maxTeachers = 200;
int: maxSurplus = 200;

% Variables
array[Schools] of var 0..maxTeachers: t;   % t[X], t[Y], t[Z], t[W]
var 0..maxSurplus: s1;
var 0..maxSurplus: s2;
var 0..maxSurplus: s3;
var 0..maxSurplus: s4;

% Constraints
constraint t[X] + t[Y] - s1 = 50;
constraint t[Y] + t[Z] - s2 = 100;
constraint t[Z] - t[W] + s3 = 20;
constraint t[X] - t[W] + s4 = 30;

% Objective
var int: total_cost = sum(i in Schools)(cost[i] * t[i]);
solve minimize total_cost;