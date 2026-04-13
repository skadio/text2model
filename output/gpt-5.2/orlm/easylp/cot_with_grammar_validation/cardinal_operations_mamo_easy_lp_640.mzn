% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: x1_min = 100; int: x1_max = 800;
int: x2_min = 50;  int: x2_max = 600;
int: x3_min = 20;  int: x3_max = 400;
int: x4_min = 40;  int: x4_max = 200;

% Variables
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;
var x4_min..x4_max: x4;

var 0..(c1*x1_max + c2*x2_max + c3*x3_max + c4*x4_max): total_cost;

% Constraints
constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% 2*x2 - x1 - x3 + x4 >= 1000
constraint 2*x2 - x1 - x3 + x4 >= 1000;

% x1 + x3 - (1/2)x2 - (7/10)x4 <= 500  ->  10*(x1+x3) - 5*x2 - 7*x4 <= 5000
constraint 10*(x1 + x3) - 5*x2 - 7*x4 <= 5000;

% (4/5)x1 + x3 - (9/10)x2 <= 1500  ->  10*x3 + 8*x1 - 9*x2 <= 15000
constraint 10*x3 + 8*x1 - 9*x2 <= 15000;

% x1 + x2 + x3 + x4 >= 200
constraint x1 + x2 + x3 + x4 >= 200;

% |(x1 + x3) - (3/5)x2| <= 300  ->  |5*(x1+x3) - 3*x2| <= 1500
constraint abs(5*(x1 + x3) - 3*x2) <= 1500;

% Objective
solve minimize total_cost;