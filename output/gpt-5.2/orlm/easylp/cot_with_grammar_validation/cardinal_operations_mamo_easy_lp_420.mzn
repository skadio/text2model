% Parameters
int: cX = 50;
int: cY = 70;

int: aX = 5;
int: aY = 3;
int: budget = 500;

int: min_total = 60;

int: diff_limit = 30;

% Variables
var 0..budget div aX: x;
var 0..budget div aY: y;

var 0..(cX*(budget div aX) + cY*(budget div aY)): total_cost;

% Constraints
constraint aX * x + aY * y <= budget;
constraint x + y >= min_total;
constraint x - 2 * y <= diff_limit;

constraint total_cost = cX * x + cY * y;

% Objective
solve minimize total_cost;