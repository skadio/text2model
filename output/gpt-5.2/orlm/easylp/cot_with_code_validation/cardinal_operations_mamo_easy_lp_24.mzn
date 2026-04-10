% Parameters
int: max_vehicles = 50;
int: cap_x_coeff = 3;
int: cap_y_coeff = 2;
int: min_capacity = 40;
int: fuel_x = 2;
int: fuel_y = 3;

% Variables
var 0..max_vehicles: x;  % vehicles on route X
var 0..max_vehicles: y;  % vehicles on route Y
var 0..(fuel_x*max_vehicles + fuel_y*max_vehicles): total_fuel;

% Constraints
constraint x + y <= max_vehicles;
constraint cap_x_coeff * x + cap_y_coeff * y >= min_capacity;
constraint total_fuel = fuel_x * x + fuel_y * y;

% Objective
solve minimize total_fuel;