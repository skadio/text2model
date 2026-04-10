% Parameters (with values embedded)
int: maxBudget = 10;
int: minStrategic = 6;
int: costX = 7;
int: costY = 3;

% Variables
var 0..maxBudget: x;  % investment units in project X (integer, non-negative)
var 0..maxBudget: y;  % investment units in project Y (integer, non-negative)

% Constraints
constraint 4*x + y <= maxBudget;
constraint x + 2*y >= minStrategic;

% Objective
var int: total_cost = costX*x + costY*y;
solve minimize total_cost;