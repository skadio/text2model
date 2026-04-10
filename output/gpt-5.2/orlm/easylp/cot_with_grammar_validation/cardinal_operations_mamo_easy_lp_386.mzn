% Parameters
int: cost1 = 50;
int: cost2 = 100;
int: cost3 = 70;
int: cost4 = 120;

int: cap12 = 500;
int: cap34 = 300;

int: dem12 = 400;
int: dem34 = 250;

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

var 0..(cost1*cap12 + cost2*cap12 + cost3*cap34 + cost4*cap34): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint 2*x1 + 4*x2 >= dem12;
constraint 3*x3 + 2*x4 >= dem34;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;