% Parameters
int: total_space = 1000;

int: min_x = 200;
int: min_y = 150;
int: min_z = 100;

int: rev_x = 5;
int: rev_y = 3;
int: rev_z = 2;

% Variables
var min_x..total_space: x;
var min_y..total_space: y;
var min_z..total_space: z;

var 0..(rev_x*total_space + rev_y*total_space + rev_z*total_space): total_cost;

% Constraints
constraint x + y + z <= total_space;

constraint total_cost = rev_x * x + rev_y * y + rev_z * z;

% Objective
solve minimize total_cost;