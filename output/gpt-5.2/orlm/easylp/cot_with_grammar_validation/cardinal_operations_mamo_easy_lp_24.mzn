% Parameters
int: max_vehicles = 50;
int: cap_req = 40;
int: capX_coeff = 3;
int: capY_coeff = 2;
int: fuelX = 2;
int: fuelY = 3;

% Variables
var 0..max_vehicles: x; % vehicles on route X
var 0..max_vehicles: y; % vehicles on route Y
var 0..(fuelX*max_vehicles + fuelY*max_vehicles): total_fuel;

% Constraints
constraint x + y <= max_vehicles;
constraint capX_coeff * x + capY_coeff * y >= cap_req;

constraint total_fuel = fuelX * x + fuelY * y;

% Objective
solve minimize total_fuel;