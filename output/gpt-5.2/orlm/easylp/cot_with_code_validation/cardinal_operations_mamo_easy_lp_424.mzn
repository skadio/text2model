% Parameters
int: a11 = 10;
int: a12 = 15;
int: b1  = 2000;

int: a21 = 12;
int: a22 = 6;
int: b2  = 800;

int: diff_bound = 100;

int: c1 = 50;
int: c2 = 75;

% Variables
var 0..200: x1;
var 0..200: x2;
var 0..25000: total_cost;

% Constraints
constraint a11 * x1 + a12 * x2 <= b1;
constraint a21 * x1 + a22 * x2 >= b2;
constraint x1 - (x2 div 2) <= diff_bound;

constraint total_cost = c1 * x1 + c2 * x2;

% Objective
solve minimize total_cost;