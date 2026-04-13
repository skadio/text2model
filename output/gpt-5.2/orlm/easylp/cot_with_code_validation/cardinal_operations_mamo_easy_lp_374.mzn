% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 5;
int: c4 = 7;

int: x1_lb = 0;    int: x1_ub = 100;
int: x2_lb = 0;    int: x2_ub = 200;
int: x3_lb = 0;    int: x3_ub = 150;
int: x4_lb = -100; int: x4_ub = 300;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= 150;
constraint x3 >= x4 + 30;

% (1/2)x1 - (3/4)x4 <= 20  ==>  2*x1 - 3*x4 <= 80
constraint 2*x1 - 3*x4 <= 80;

% x2 - (1/4)x3 >= -50  ==>  4*x2 - x3 >= -200
constraint 4*x2 - x3 >= -200;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;