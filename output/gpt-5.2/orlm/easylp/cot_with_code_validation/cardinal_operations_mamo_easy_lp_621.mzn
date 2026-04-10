% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 5;
int: c4 = 4;

int: cap12 = 1000;
int: cap34 = 1200;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..1200: x3;
var 0..1200: x4;

var 0..(c1*1000 + c2*1000 + c3*1200 + c4*1200): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% x1 >= (4/3)*x3  <=>  3*x1 >= 4*x3
constraint 3*x1 >= 4*x3;

% x2 > (9/7)*x4 + 200  with integer vars -> 7*x2 >= 9*x4 + 1401
constraint 7*x2 >= 9*x4 + 1401;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;