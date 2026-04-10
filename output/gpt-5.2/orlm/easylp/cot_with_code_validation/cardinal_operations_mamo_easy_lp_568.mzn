% Parameters
int: costX = 1000;
int: costY = 500;
int: costZ = 1200;

int: total_limit = 100;

int: x_min = 0;
int: x_max = 50;

int: y_min = 0;
int: y_max = 40;

int: z_min = 0;
int: z_max = 60;

int: x_at_least_y_plus = 10;
int: z_at_most_y_plus = 20;

% Variables
var x_min..x_max: X;
var y_min..y_max: Y;
var z_min..z_max: Z;

var 0..(costX*x_max + costY*y_max + costZ*z_max): total_cost;

% Constraints
constraint X + Y + Z <= total_limit;

constraint X >= Y + x_at_least_y_plus;

constraint Z <= Y + z_at_most_y_plus;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;