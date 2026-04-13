% Parameters
int: maxX1 = 200;
int: maxX2 = 150;
int: maxX3 = 120;
int: maxX4 = 90;

int: c1 = 5000;
int: c2 = 4000;
int: c3 = 6000;
int: c4 = 7000;

% Variables
var 0..maxX1: X1;
var 0..maxX2: X2;
var 0..maxX3: X3;
var 0..maxX4: X4;

var int: total_cost;

% Constraints
constraint X1 + X2 >= 100;
constraint 2*X2 + 3*X3 <= 250;
constraint X4 - X1 >= 50;
constraint X3 - 2*X4 <= -30;

constraint total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

% Objective
solve minimize total_cost;