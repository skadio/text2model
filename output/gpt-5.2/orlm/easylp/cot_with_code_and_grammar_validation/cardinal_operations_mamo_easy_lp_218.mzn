% Parameters
int: max_total_units = 5000;
int: min_x_offset = 1000;          % X >= 1000 + 0.5*Y  ->  2X >= 2000 + Y
int: z_offset = 1500;              % Z <= 0.75*X + 1500 ->  4Z <= 3X + 6000

int: costX = 5;
int: costY = 10;
int: costZ = 20;

% Variables
var 0..max_total_units: X;
var 0..max_total_units: Y;
var 0..max_total_units: Z;

var 0..(costX*max_total_units + costY*max_total_units + costZ*max_total_units): total_cost;

% Constraints
constraint X + Y + Z <= max_total_units;

% Diversity constraint: X >= 1000 + 0.5*Y, using integer form
constraint 2 * X >= 2 * min_x_offset + Y;

% Overstock constraint: Z <= 0.75*X + 1500, using integer form
constraint 4 * Z <= 3 * X + 4 * z_offset;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;