% Parameters
float: costX = 0.5;
float: costY = 0.3;
int: cap = 5000;

% Variables
var 0..cap: x;
var 0..cap: y;

% Constraints
constraint 2 * x + 3 * y <= cap;
constraint abs(x - y) >= 100;

% Objective
solve minimize round(costX * int2float(x) + costY * int2float(y));