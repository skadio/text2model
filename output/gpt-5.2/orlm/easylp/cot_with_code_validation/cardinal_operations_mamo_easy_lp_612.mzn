% Parameters
int: land_cap = 1000;
int: min_diversity = 500;
int: diff_cap = 200;

int: c1 = 50;
int: c2 = 30;
int: c3 = 20;
int: c4 = 10;

% Variables
var 0..land_cap: x1;
var 0..land_cap: x2;
var 0..land_cap: x3;
var 0..land_cap: x4;

var 0..(c1*land_cap + c2*land_cap + c3*land_cap + c4*land_cap): total_cost;

% Constraints
constraint x1 + x2 <= land_cap;

constraint 2*x3 + 3*x4 >= min_diversity;

constraint abs(x1 - x4) <= diff_cap;

% (1/2)*x3 >= x2  <=>  x3 >= 2*x2
constraint x3 >= 2*x2;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;