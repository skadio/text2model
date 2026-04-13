% Parameters
int: costX = 200000;
int: costY = 300000;
int: maxProps = 10;

% Variables
var 1..maxProps: x; % properties at location X
var 1..maxProps: y; % properties at location Y
var 0..(costX * maxProps + costY * maxProps): totalCost;

% Constraints
constraint x + y <= maxProps;
constraint x >= 3 * y;
constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;