% Parameters
int: c1 = 10;
int: c2 = 20;
int: c3 = 30;

int: b1 = 2000;   % x1 + 2*x2 <= 2000
int: b2 = 1000;   % 3*x1 + 4*x3 >= 1000
int: b3 = 500;    % x2 - 5*x3 <= 500

% Variables
var 0..2000: x1;
var 0..1000: x2;
var 0..500: x3;

var 0..(c1*2000 + c2*1000 + c3*500): total_cost;

% Constraints
constraint x1 + 2*x2 <= b1;
constraint 3*x1 + 4*x3 >= b2;
constraint x2 - 5*x3 <= b3;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;