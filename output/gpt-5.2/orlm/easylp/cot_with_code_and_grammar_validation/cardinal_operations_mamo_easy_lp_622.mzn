% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: b12 = 1000;
int: b34 = 800;

int: u1 = 500;
int: u2 = 600;
int: u3 = 400;
int: u4 = 300;

% Variables
var 0..u1: x1;
var 0..u2: x2;
var 0..u3: x3;
var 0..u4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= b12;
constraint x3 + x4 <= b34;

% Use integer arithmetic to avoid fractions:
% 0.5*x1 - 0.6*x2 >= 50  <=>  5*x1 - 6*x2 >= 500
constraint 5*x1 - 6*x2 >= 500;

% 0.7*x4 - x3 <= 70  <=>  7*x4 - 10*x3 <= 700
constraint 7*x4 - 10*x3 <= 700;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;