% Parameters
int: max_total = 100;
int: min_total = 30;
int: min_effect = 120;

int: costX = 4;
int: costY = 5;

int: effX = 2;
int: effY = 3;

% Variables
var 0..max_total: x;
var 0..max_total: y;
var 0..(costX*max_total + costY*max_total): total_cost;

% Constraints
constraint x + y <= max_total;
constraint x + y >= min_total;

constraint effX * x + effY * y >= min_effect;

constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;