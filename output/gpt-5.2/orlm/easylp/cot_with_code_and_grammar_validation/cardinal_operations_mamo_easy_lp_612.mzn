% Parameters
int: land_max = 1000;
int: diversity_min = 500;
int: diff_max = 200;

int: c1 = 50;
int: c2 = 30;
int: c3 = 20;
int: c4 = 10;

% Variables
var 0..land_max: x1;
var 0..land_max: x2;
var 0..land_max: x3;
var 0..land_max: x4;

var 0..(c1*land_max + c2*land_max + c3*land_max + c4*land_max): total_cost;

% Constraints
constraint x1 + x2 <= land_max;

constraint 2*x3 + 3*x4 >= diversity_min;

constraint abs(x1 - x4) <= diff_max;

% (1/2)*x3 >= x2  <=>  x3 >= 2*x2
constraint x3 >= 2*x2;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;