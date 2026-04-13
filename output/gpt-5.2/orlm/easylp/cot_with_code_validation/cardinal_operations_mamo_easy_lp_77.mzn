% Parameters
int: max_hours = 120;
int: min_total_hours = 40;

int: aX = 2;
int: aY = 3;

int: costX = 50;
int: costY = 30;

% Variables
var 0..max_hours: x;  % hours allocated to task X (integer)
var 0..max_hours: y;  % hours allocated to task Y (integer)
var 0..(costX*max_hours + costY*max_hours): total_cost;

% Constraints
constraint aX * x + aY * y <= max_hours;
constraint x + y >= min_total_hours;

constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;