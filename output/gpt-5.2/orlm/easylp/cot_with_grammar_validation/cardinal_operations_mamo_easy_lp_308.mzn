% Parameters
int: max_units = 10000;
int: min_effectiveness = 20000;

int: effX = 5;
int: effY = 3;
int: effZ = 7;

int: costX = 500;
int: costY = 300;
int: costZ = 700;

% Variables
var 0..max_units: X;
var 0..max_units: Y;
var 0..max_units: Z;

var 0..(costX*max_units + costY*max_units + costZ*max_units): total_cost;

% Constraints
constraint X + Y + Z <= max_units;
constraint effX*X + effY*Y + effZ*Z >= min_effectiveness;

constraint X >= Y;
constraint Z <= Y;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;