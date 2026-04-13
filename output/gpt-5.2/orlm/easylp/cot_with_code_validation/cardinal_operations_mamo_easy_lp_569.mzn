% Parameters
int: c1 = 4;
int: c2 = 5;
int: c3 = 6;

int: b1 = 1000;   % x1 + 2*x2 <= 1000
int: b2 = 600;    % x2 + 3*x3 >= 600
int: b3 = 500;    % 2*x3 - x1 == 500

% Variables
var 0..1000: x1;
var 0..500: x2;
var 250..500: x3;

var 0..10000: total_cost;

% Constraints
constraint x1 + 2*x2 <= b1;
constraint x2 + 3*x3 >= b2;
constraint 2*x3 - x1 == b3;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;