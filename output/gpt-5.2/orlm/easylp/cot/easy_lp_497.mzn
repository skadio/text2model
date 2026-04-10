% Parameters (with values embedded)
int: max_total_ships = 100;
int: min_capacity = 60;
int: max_diff = 30;

int: costX = 10;
int: costY = 20;

int: maxX = 70;
int: maxY = 50;

% Variables
var 0..maxX: x; % ships on Route X
var 0..maxY: y; % ships on Route Y
var 0..(costX*maxX + costY*maxY): total_cost;

% Constraints
constraint x + y <= max_total_ships;
constraint 2*x + y >= min_capacity;
constraint abs(x - y) <= max_diff;
constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;