% Parameters (with values embedded)
int: min_total_resources = 50;
int: max_constraint1 = 30; % 4*X - Y <= 30
int: min_constraint2 = 10; % Z - 2*Y >= 10

int: costX = 5;
int: costY = 3;
int: costZ = 2;

% Variable bounds (safe upper bounds derived from constraints)
% From 4*X - Y <= 30 and Y >= 0 => X <= 7 (since 4*X <= 30)
int: ubX = 7;
% With X <= 7 and X+Y+Z >= 50, a safe upper bound for Y, Z is 50
int: ubYZ = 50;

% Variables
var 0..ubX: X;
var 0..ubYZ: Y;
var 0..ubYZ: Z;

var 0..1000: total_cost;

% Constraints
constraint X + Y + Z >= min_total_resources;
constraint 4 * X - Y <= max_constraint1;
constraint Z - 2 * Y >= min_constraint2;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;