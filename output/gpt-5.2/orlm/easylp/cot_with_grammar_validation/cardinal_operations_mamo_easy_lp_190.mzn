% Parameters
int: capacity = 1000;
int: demand_xy = 500;          % minimum for (2*X + Y)
int: balance_xz = 400;         % minimum for (X + Z)

int: cost_x = 2;
int: cost_y = 3;
int: cost_z = 4;

% Variables
var 0..capacity: X;
var 0..capacity: Y;
var 0..capacity: Z;

var 0..(cost_x*capacity + cost_y*capacity + cost_z*capacity): total_cost;

% Constraints
constraint X + Y + Z <= capacity;
constraint 2*X + Y >= demand_xy;
constraint X + Z >= balance_xz;

constraint total_cost = cost_x*X + cost_y*Y + cost_z*Z;

% Objective
solve minimize total_cost;