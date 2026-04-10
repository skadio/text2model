% Parameters
int: c1 = 500;
int: c2 = 700;
int: c3 = 900;

int: max_total = 10;

int: a1 = 5;
int: a2 = 4;
int: min_a = 30;

int: b1 = 7;
int: b3 = 6;
int: max_b = 20;

% Variables
var 0..max_total: X1;
var 0..max_total: X2;
var 0..max_total: X3;

var 0..(c1*max_total + c2*max_total + c3*max_total): total_cost;

% Constraints
constraint X1 + X2 + X3 <= max_total;

constraint a1*X1 + a2*X2 >= min_a;

constraint b1*X1 - b3*X3 <= max_b;

constraint X2 - (X1 + X3) >= 0;

constraint total_cost = c1*X1 + c2*X2 + c3*X3;

% Objective
solve minimize total_cost;