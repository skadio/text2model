% Parameters
int: cost_x1 = 100;
int: cost_x2 = 200;
int: cost_x3 = 150;
int: cost_x4 = 50;

int: ub_x1 = 500;
int: ub_x2 = 300;
int: ub_x3 = 200;
int: ub_x4 = 400;

% Variables
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;
var 0..ub_x4: x4;

var 0..(cost_x1*ub_x1 + cost_x2*ub_x2 + cost_x3*ub_x3 + cost_x4*ub_x4): total_cost;

% Constraints
constraint x1 + x2 <= 1000;

constraint 2*x1 + x3 >= 800;

constraint 2*x4 >= x1;

constraint abs(x3 - 4*x2) <= 2000;

constraint (x2 + x4) - (x1 + x3) = 70;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Objective
solve minimize total_cost;