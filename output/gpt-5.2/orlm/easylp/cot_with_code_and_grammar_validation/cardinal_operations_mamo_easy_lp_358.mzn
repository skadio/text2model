% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: cap12 = 2000;
int: req34 = 3000;
int: diff14 = 500;
int: gap23 = 1000;

% Variables
var 0..100000: X1;
var 0..100000: X2;
var 0..100000: X3;
var 0..100000: X4;

var 0..1000000000: total_cost;

% Constraints
constraint X1 + X2 <= cap12;
constraint 2 * X3 + 3 * X4 >= req34;
constraint X1 - X4 <= diff14;
constraint X4 - X1 <= diff14;
constraint X2 >= X3 + gap23;

constraint total_cost = c1 * X1 + c2 * X2 + c3 * X3 + c4 * X4;

% Objective
solve minimize total_cost;