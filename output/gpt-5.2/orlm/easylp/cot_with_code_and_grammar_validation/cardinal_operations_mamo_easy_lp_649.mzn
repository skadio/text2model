% Parameters
int: cost1 = 5;
int: cost2 = 6;
int: cost3 = 7;
int: cost4 = 8;

int: cap12 = 1000;
int: cap34 = 800;

int: req1 = 200;  % x1 - 0.5*x3 >= 200  ->  2*x1 - x3 >= 400
int: req2 = 150;  % 0.25*x4 - x2 >= 150 -> x4 - 4*x2 >= 600

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

var 0..(cost1*cap12 + cost2*cap12 + cost3*cap34 + cost4*cap34): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint 2*x1 - x3 >= 2*req1;       % 2*x1 - x3 >= 400
constraint x4 - 4*x2 >= 4*req2;        % x4 - 4*x2 >= 600

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;