% Parameters
int: minX = 10;
int: minY = 5;
int: maxTotal = 40;
int: costX = 50;
int: costY = 80;

% Variables
var minX..maxTotal: x_hours;
var minY..maxTotal: y_hours;
var 0..(costX*maxTotal + costY*maxTotal): total_cost;

% Constraints
constraint x_hours + y_hours <= maxTotal;
constraint total_cost = costX * x_hours + costY * y_hours;

% Objective
solve minimize total_cost;