% Parameters
int: total_capacity = 500;

int: min_x = 100;
int: min_y = 150;
int: min_z = 200;

int: max_x = 300;
int: max_y = 400;
int: max_z = 600;

int: cost_x = 5;
int: cost_y = 10;
int: cost_z = 15;

% Variables
var 0..max_x: X;
var 0..max_y: Y;
var 0..max_z: Z;

var 0..(cost_x*max_x + cost_y*max_y + cost_z*max_z): total_cost;

% Constraints
constraint X >= min_x;
constraint Y >= min_y;
constraint Z >= min_z;

constraint X + Y + Z <= total_capacity;

constraint total_cost = cost_x*X + cost_y*Y + cost_z*Z;

% Objective
solve minimize total_cost;