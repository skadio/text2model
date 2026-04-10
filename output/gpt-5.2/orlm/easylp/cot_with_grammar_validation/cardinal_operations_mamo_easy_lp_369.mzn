% Parameters
int: cost1 = 150;
int: cost2 = 200;
int: cost3 = 300;
int: cost4 = 400;

int: cap12 = 1000;
int: cap34 = 500;

int: req12 = 1200;   % 2*X1 + 3*X2 >= req12
int: req34 = 2500;   % 5*X3 + 6*X4 >= req34

% Variables
var 0..cap12: X1;
var 0..cap12: X2;
var 0..cap34: X3;
var 0..cap34: X4;

var 0..(cost1*cap12 + cost2*cap12 + cost3*cap34 + cost4*cap34): total_cost;

% Constraints
constraint X1 + X2 <= cap12;
constraint X3 + X4 <= cap34;

constraint 2*X1 + 3*X2 >= req12;
constraint 5*X3 + 6*X4 >= req34;

constraint total_cost = cost1*X1 + cost2*X2 + cost3*X3 + cost4*X4;

% Objective
solve minimize total_cost;