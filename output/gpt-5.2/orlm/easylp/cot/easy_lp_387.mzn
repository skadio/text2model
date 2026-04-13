% Parameters (with values embedded)
int: price_x1 = 100;
int: price_x2 = 200;
int: price_x3 = 300;
int: price_x4 = 400;

int: cap12 = 50;
int: cap34 = 80;

% Weighted minimum "quality" requirements
% 0.6*x1 + 0.8*x2 >= 20
% 0.7*x3 + 0.9*x4 >= 30
% Multiply by 10 to keep integers:
% 6*x1 + 8*x2 >= 200
% 7*x3 + 9*x4 >= 300
int: q12_rhs = 200;
int: q34_rhs = 300;

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint 6*x1 + 8*x2 >= q12_rhs;
constraint 7*x3 + 9*x4 >= q34_rhs;

% Objective
var int: total_cost = price_x1*x1 + price_x2*x2 + price_x3*x3 + price_x4*x4;
solve minimize total_cost;