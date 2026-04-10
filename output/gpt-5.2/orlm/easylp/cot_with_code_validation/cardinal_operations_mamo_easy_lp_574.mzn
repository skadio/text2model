% Parameters
int: c1 = 4;
int: c2 = 5;
int: c3 = 6;

int: ub1 = 1500;
int: ub2 = 1200;
int: ub3 = 800;

int: cap12 = 2000;
int: dem23 = 1000;
int: rhs_eq = 500;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;

var 0..(c1*ub1 + c2*ub2 + c3*ub3): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x2 + x3 >= dem23;
constraint x1 - 2*x3 = rhs_eq;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;