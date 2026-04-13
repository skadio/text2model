% Parameters
int: costX = 4;
int: costY = 5;

int: capX = 2;
int: capY = 3;
int: capMax = 1000;

int: demX = 3;
int: demY = 2;
int: demMin = 800;

% Variables
var 0..capMax: x;
var 0..capMax: y;
var 0..(costY * capMax): total_cost;

% Constraints
constraint capX * x + capY * y <= capMax;
constraint demX * x + demY * y >= demMin;

constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;