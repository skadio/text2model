% Parameters
int: c1 = 4;
int: c2 = 2;
int: c3 = 3;
int: c4 = 5;

int: M = 10000; % safe big-M for absolute value linearization

% Variables
var 0..10000: x1;
var 0..10000: x2;
var 0..10000: x3;
var 0..10000: x4;

var 0..(c1*10000 + c2*10000 + c3*10000 + c4*10000): total_cost;

% Constraints
constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% |0.5*x2 - x1| <= 100  ->  |x2 - 2*x1| <= 200
constraint x2 - 2*x1 <= 200;
constraint 2*x1 - x2 <= 200;

% x1 >= 200 + 0.7*x3  ->  10*x1 >= 2000 + 7*x3
constraint 10*x1 >= 2000 + 7*x3;

% |x4 - 0.6*x2| <= 150  ->  |10*x4 - 6*x2| <= 1500
constraint 10*x4 - 6*x2 <= 1500;
constraint 6*x2 - 10*x4 <= 1500;

% |0.8*x3 - x1| <= 300  ->  |4*x3 - 5*x1| <= 1500
constraint 4*x3 - 5*x1 <= 1500;
constraint 5*x1 - 4*x3 <= 1500;

% x4 >= x2 + 50
constraint x4 >= x2 + 50;

% Objective
solve minimize total_cost;