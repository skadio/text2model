% Parameters
int: max_vehicles = 50;
int: demand = 100;

int: capX = 3;
int: capY = 2;

int: fuelX = 2;
int: fuelY = 3;

% Variables
var 0..max_vehicles: x;
var 0..max_vehicles: y;

var 0..(max_vehicles * max(fuelX, fuelY)): total_fuel;

% Constraints
constraint x + y <= max_vehicles;
constraint capX * x + capY * y >= demand;

constraint total_fuel = fuelX * x + fuelY * y;

% Objective
solve minimize total_fuel;