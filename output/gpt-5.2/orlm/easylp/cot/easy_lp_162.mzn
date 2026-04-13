% Parameters (with values embedded)
int: costX = 200000;
int: costY = 300000;
int: maxTotalProps = 10;

% Variables
var 1..maxTotalProps: x; % number of properties in location X
var 1..maxTotalProps: y; % number of properties in location Y

% Constraints
constraint x + y <= maxTotalProps;
constraint x >= 3 * y;

% Objective
var int: totalCost = costX * x + costY * y;
solve minimize totalCost;