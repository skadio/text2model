% Parameters (with values embedded)
int: max_total_vehicles = 1000;
int: min_2x_plus_3y = 500;
int: max_x_plus_z_minus_y = 400;
int: min_y_minus_z = 100;

int: costX = 5;
int: costY = 7;
int: costZ = 3;

% Variables
var 0..max_total_vehicles: X;
var 0..max_total_vehicles: Y;
var 0..max_total_vehicles: Z;

var 0..(costX*max_total_vehicles + costY*max_total_vehicles + costZ*max_total_vehicles): total_cost;

% Constraints
constraint X + Y + Z <= max_total_vehicles;
constraint 2*X + 3*Y >= min_2x_plus_3y;
constraint X + Z - Y <= max_x_plus_z_minus_y;
constraint Y - Z >= min_y_minus_z;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;