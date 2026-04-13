% Parameters (with values embedded)
int: max_total_hours = 50;
int: min_quality = 100;
int: max_other_measure = 75;

int: costX = 100;
int: costY = 200;
int: costZ = 150;

% Variables
var 0..max_total_hours: X;
var 0..max_total_hours: Y;
var 0..max_total_hours: Z;

var 0..(max_total_hours * max([costX, costY, costZ])): total_cost;

% Constraints
constraint X + Y + Z <= max_total_hours;

constraint 3*X + 4*Y + 1*Z >= min_quality;

constraint 2*X - Y + Z <= max_other_measure;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;