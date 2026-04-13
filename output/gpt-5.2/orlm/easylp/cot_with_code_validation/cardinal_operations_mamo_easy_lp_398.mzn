% Parameters
int: cost_x1 = 10;
int: cost_x2 = 20;
int: cost_x3 = 30;
int: cost_x4 = 40;

int: ub_x1 = 100;
int: ub_x2 = 100;
int: ub_x3 = 100;
int: ub_x4 = 100;

% Variables
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;
var 0..ub_x4: x4;

var 0..(cost_x1*ub_x1 + cost_x2*ub_x2 + cost_x3*ub_x3 + cost_x4*ub_x4): total_cost;

% Constraints
constraint x1 + x2 <= 100;
constraint x3 + x4 >= 50;
constraint 2*x1 + 3*x2 - x3 <= 0;
constraint 4*x3 - 2*x2 = 5*x4;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Objective
solve minimize total_cost;