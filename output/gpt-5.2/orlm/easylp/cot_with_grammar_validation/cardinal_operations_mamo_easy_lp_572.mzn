% Parameters
int: max_total = 100;

int: c1 = 50000;
int: c2 = 70000;
int: c3 = 60000;

int: x1_min = 10;
int: x1_max = 50;
int: x2_min = 20;
int: x2_max = 70;
int: x3_min = 0;
int: x3_max = 40;

% Variables
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;

var 0..(c1*x1_max + c2*x2_max + c3*x3_max): total_cost;

% Constraints
constraint x1 + x2 + x3 <= max_total;

% 0.5*x1 + 0.6*x3 >= 0.7*x2 + 20
% Multiply by 10: 5*x1 + 6*x3 >= 7*x2 + 200
constraint 5*x1 + 6*x3 >= 7*x2 + 200;

% 0.8*x2 + 0.9*x3 <= x1 + 30
% Multiply by 10: 8*x2 + 9*x3 <= 10*x1 + 300
constraint 8*x2 + 9*x3 <= 10*x1 + 300;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;