% Parameters
int: costX = 200000;
int: costY = 300000;
int: maxProps = 10;

% Variables
var 1..maxProps: x;
var 1..maxProps: y;
var 0..(costX*maxProps + costY*maxProps): total_cost;

% Constraints
constraint x + y <= maxProps;
constraint x >= 3 * y;
constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;