% Parameters
int: X1_min = 0;
int: X1_max = 2000;
int: X2_min = 0;
int: X2_max = 1500;
int: X3_min = 500;
int: X3_max = 1500;
int: X4_min = 500;
int: X4_max = 2000;

int: cap12 = 5000;
int: cap34 = 3000;

float: c1 = 0.5;
float: c2 = 0.3;
float: c3 = 0.4;
float: c4 = 0.6;

% Variables
var X1_min..X1_max: X1;
var X2_min..X2_max: X2;
var X3_min..X3_max: X3;
var X4_min..X4_max: X4;

var float: total_cost;

% Constraints
constraint X1 + X2 <= cap12;
constraint X2 >= X3 + 1000;
constraint X3 + 2 * X4 <= cap34;
constraint X4 >= X1 + 100;

constraint total_cost = c1 * X1 + c2 * X2 + c3 * X3 + c4 * X4;

% Objective
solve minimize total_cost;