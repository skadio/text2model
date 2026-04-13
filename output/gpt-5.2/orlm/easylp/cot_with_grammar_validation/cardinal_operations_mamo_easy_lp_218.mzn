% Parameters
int: max_total_units = 5000;
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

% X must be at least 1000 more than half of Y: X >= Y/2 + 1000  <=>  2X - Y >= 2000
constraint 2 * X - Y >= 2000;

% Z should not exceed 75% of X by more than 1500: Z <= 0.75X + 1500  <=>  4Z <= 3X + 6000
constraint 4 * Z <= 3 * X + 6000;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;