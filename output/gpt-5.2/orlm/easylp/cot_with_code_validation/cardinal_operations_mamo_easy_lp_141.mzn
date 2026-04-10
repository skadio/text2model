% Parameters
int: min_units = 10;
int: max_firepower = 50;
int: firepower_X = 5;
int: firepower_Y = 3;
int: cost_X = 1000;
int: cost_Y = 2000;

% Variables
var 0..max_firepower div firepower_X: X;
var 0..max_firepower div firepower_Y: Y;
var 0..(cost_X * (max_firepower div firepower_X) + cost_Y * (max_firepower div firepower_Y)): total_cost;

% Constraints
constraint X + Y >= min_units;

constraint firepower_X * X + firepower_Y * Y <= max_firepower;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;