% Parameters
int: c1 = 4;
int: c2 = 3;
int: c3 = 5;
int: c4 = 6;

int: max_x1 = 300;
int: max_x2 = 500;
int: max_x3 = 2000;
int: max_x4 = 30;

int: rhs1 = 1000;
int: rhs2 = 2000;
int: rhs3 = 500;
int: rhs4 = 70;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

var 0..(c1*max_x1 + c2*max_x2 + c3*max_x3 + c4*max_x4): total_cost;

% Constraints
constraint x1 + x2 <= rhs1;

constraint 2*x1 + 3*x3 >= rhs2;

% x2 - 0.5*x4 <= 500  <=>  2*x2 - x4 <= 1000
constraint 2*x2 - x4 <= 2*rhs3;

constraint abs(x1 - (x2 + x3)) <= rhs4;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;