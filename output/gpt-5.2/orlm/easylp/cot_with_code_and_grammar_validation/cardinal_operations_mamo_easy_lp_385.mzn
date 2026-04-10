% Parameters
int: cost_x1 = 100;
int: cost_x2 = 200;
int: cost_x3 = 300;
int: cost_x4 = 400;

int: max_x1 = 20;
int: max_x2 = 15;
int: max_x3 = 25;
int: max_x4 = 30;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= 30;
constraint 2*x3 + x4 <= 40;
constraint x1 + x2 + x3 >= 20;
constraint x3 - x4 div 2 <= 10;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Objective
solve minimize total_cost;