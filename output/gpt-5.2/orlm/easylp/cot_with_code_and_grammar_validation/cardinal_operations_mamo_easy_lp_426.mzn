% Parameters
int: costX = 50;
int: costY = 75;

int: cap_total = 1200;
int: min_gap = 300;              % X - Y >= 300
int: cap_storage = 2000;         % 2*X + Y <= 2000

% Variables
var 0..cap_total: x;             % units of product X
var 0..cap_total: y;             % units of product Y
var 0..(costX*cap_total + costY*cap_total): total_cost;

% Constraints
constraint x + y <= cap_total;
constraint x - y >= min_gap;
constraint 2*x + y <= cap_storage;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;