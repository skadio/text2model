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
var int: X1;
var int: X2;
var int: X3;
var int: X4;

var int: total_cost;

% Constraints
constraint X1 + X2 <= cap12;
constraint 2*X3 + 3*X4 >= req34;
constraint abs(X1 - X4) <= diff14;
constraint X2 >= X3 + gap23;

constraint X1 >= 0;
constraint X2 >= 0;
constraint X3 >= 0;
constraint X4 >= 0;

constraint total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

% Objective
solve minimize total_cost;