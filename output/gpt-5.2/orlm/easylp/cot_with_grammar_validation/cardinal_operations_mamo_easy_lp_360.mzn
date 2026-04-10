% Parameters
int: cost1 = 50;
int: cost2 = 75;
int: cost3 = 100;
int: cost4 = 125;

int: cap12 = 5000;
int: cap34 = 3000;

int: min13 = 2000;
int: min24 = 4000;

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

var 0..(cost1*cap12 + cost2*cap12 + cost3*cap34 + cost4*cap34): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;