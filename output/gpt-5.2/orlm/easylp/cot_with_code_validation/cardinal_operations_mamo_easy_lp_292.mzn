% Parameters
int: total_alloc_max = 100;
int: yz_alloc_max = 70;

int: costX = 3;
int: costY = 2;
int: costZ = 5;

int: x_min = 0;
int: x_max = 50;

int: y_min = 0;
int: y_max = 30;

int: z_min = 0;
int: z_max = total_alloc_max; % implied by total allocation constraint

% Variables
var x_min..x_max: X;
var y_min..y_max: Y;
var z_min..z_max: Z;

var 0..(costX*x_max + costY*y_max + costZ*z_max): total_cost;

% Constraints
constraint X + Y + Z <= total_alloc_max;
constraint X >= 2 * Y + 10;
constraint Y + Z <= yz_alloc_max;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;