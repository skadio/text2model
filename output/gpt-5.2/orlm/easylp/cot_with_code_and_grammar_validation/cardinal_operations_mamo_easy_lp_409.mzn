% Parameters
int: cost_x1 = 200000;
int: cost_x2 = 300000;
int: cost_x3 = 500000;
int: cost_x4 = 700000;

int: ub_x1 = 20;
int: ub_x2 = 30;
int: ub_x3 = 15;
int: ub_x4 = 10;

% Variables
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;
var 0..ub_x4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= 50;

constraint 2 * x3 + x4 >= 60;

% 3*x1 + 4.5*x2 <= 100  =>  6*x1 + 9*x2 <= 200
constraint 6 * x1 + 9 * x2 <= 200;

% 6*x3 - 0.5*x4 <= 80  =>  12*x3 - x4 <= 160
constraint 12 * x3 - x4 <= 160;

constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;