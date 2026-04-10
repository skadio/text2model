% Parameters (with values embedded)
int: c1 = 4;
int: c2 = 3;
int: c3 = 5;
int: c4 = 6;

int: M = 10; % scale factor to model decimals exactly

% Variables
var 0..100000: X1;
var 0..100000: X2;
var 0..100000: X3;
var 0..100000: X4;

var 0..1000000000: total_cost;

% Constraints
constraint X1 + X2 <= 1000;

constraint 2*X2 + X3 >= 500;

% (1/2)X3 - X1 <= 200  ->  X3 - 2*X1 <= 400
constraint X3 - 2*X1 <= 400;

% X4 - X2 >= -400
constraint X4 - X2 >= -400;

% 0.8*X4 - X3 <= -300  ->  (8/10)X4 - X3 <= -300  ->  8*X4 - 10*X3 <= -3000
constraint 8*X4 - 10*X3 <= -3000;

constraint total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

% Objective
solve minimize total_cost;