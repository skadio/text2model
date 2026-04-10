% Parameters
int: total_limit = 100;

int: c1 = 50000;
int: c2 = 70000;
int: c3 = 60000;

int: x1_lb = 10;
int: x1_ub = 50;

int: x2_lb = 20;
int: x2_ub = 70;

int: x3_lb = 0;
int: x3_ub = 40;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;

var int: total_cost;

% Constraints
constraint x1 + x2 + x3 <= total_limit;

% (1/2)x1 + (6/10)x3 >= (7/10)x2 + 20
% Multiply by 10: 5x1 + 6x3 >= 7x2 + 200
constraint 5*x1 + 6*x3 - 7*x2 >= 200;

% (8/10)x2 + (9/10)x3 <= x1 + 30
% Multiply by 10: 8x2 + 9x3 <= 10x1 + 300
constraint 8*x2 + 9*x3 - 10*x1 <= 300;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;