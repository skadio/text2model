% Parameters
int: max_total_hours = 50;
int: min_quality = 100;
int: max_measure = 75;

int: cost_X = 100;
int: cost_Y = 200;
int: cost_Z = 150;

% Variables
var 0..max_total_hours: X;
var 0..max_total_hours: Y;
var 0..max_total_hours: Z;

var 0..(max_total_hours * max(cost_X, max(cost_Y, cost_Z))): total_cost;

% Constraints
constraint X + Y + Z <= max_total_hours;

constraint 3*X + 4*Y + 1*Z >= min_quality;

constraint 2*X - 1*Y + 1*Z <= max_measure;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;