% Parameters (with values embedded)
int: costX1 = 2;
int: costX2 = 3;
int: costX3 = 4;
int: costX4 = 5;

int: ubX1 = 300;
int: ubX2 = 200;
int: ubX3 = 300;
int: ubX4 = 400;

int: cap12 = 500;
int: cap34 = 600;
int: min13 = 300;
int: min24 = 400;

% Variables
var 0..ubX1: X1;
var 0..ubX2: X2;
var 0..ubX3: X3;
var 0..ubX4: X4;

var 0..1000000: total_cost;

% Constraints
constraint X1 + X2 <= cap12;
constraint X3 + X4 <= cap34;
constraint X1 + X3 >= min13;
constraint X2 + X4 >= min24;

constraint total_cost = costX1*X1 + costX2*X2 + costX3*X3 + costX4*X4;

% Objective
solve minimize total_cost;