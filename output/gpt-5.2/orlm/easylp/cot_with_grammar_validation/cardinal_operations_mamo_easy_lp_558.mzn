% Parameters
int: total_alloc = 500;

int: min_x = 100;
int: min_y = 50;
int: min_z = 20;

int: max_x = 300;
int: max_y = 200;
int: max_z = 100;

int: cost_x = 40;
int: cost_y = 60;
int: cost_z = 100;

% Variables
var min_x..max_x: X;
var min_y..max_y: Y;
var min_z..max_z: Z;

var 0..(cost_x*max_x + cost_y*max_y + cost_z*max_z): total_cost;

% Constraints
constraint X + Y + Z <= total_alloc;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;