% Parameters
int: total_budget = 200;
float: wX = 0.6;
float: wY = 0.8;
float: min_impact = 120.0;
int: max_diff_XY = 50;

int: costX = 50;
int: costY = 80;

int: maxX = 150;
int: maxY = 100;

% Variables
var 0..maxX: X;
var 0..maxY: Y;

var 0..(costX*maxX + costY*maxY): total_cost;

% Constraints
constraint X + Y <= total_budget;

constraint wX * int2float(X) + wY * int2float(Y) >= min_impact;

constraint X - Y <= max_diff_XY;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;