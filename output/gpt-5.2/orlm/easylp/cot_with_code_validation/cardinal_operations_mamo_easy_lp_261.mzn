% Parameters
int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

int: total_hires = 50;

int: expX = 5;
int: expY = 3;
int: expZ = 7;
int: min_experience = 200;

int: minX = 10;
int: maxY = 20;

% Variables
var 0..total_hires: x;
var 0..total_hires: y;
var 0..total_hires: z;

var 0..(total_hires * max(costX, max(costY, costZ))): total_cost;

% Constraints
constraint x + y + z = total_hires;

constraint expX * x + expY * y + expZ * z >= min_experience;

constraint x >= minX;
constraint y <= maxY;

constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;