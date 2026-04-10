% Parameters (with values embedded)
int: max_x1 = 300;
int: max_x2 = 200;
int: max_x3 = 500;
int: max_x4 = 700;

int: sum12 = 400;
int: max_sum34 = 1000;

int: c1 = 20;
int: c2 = 15;
int: c3 = 10;
int: c4 = 5;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 = sum12;
constraint x3 + x4 <= max_sum34;
constraint x3 + x4 >= x1 + x2;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;