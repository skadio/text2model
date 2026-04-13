% Parameters
int: cost1 = 150;
int: cost2 = 200;
int: cost3 = 300;
int: cost4 = 400;

int: cap12 = 1000;
int: cap34 = 500;

int: req12 = 1200;
int: req34 = 2500;

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

var 0..(cost1*cap12 + cost2*cap12 + cost3*cap34 + cost4*cap34): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint 2*x1 + 3*x2 >= req12;
constraint 5*x3 + 6*x4 >= req34;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;