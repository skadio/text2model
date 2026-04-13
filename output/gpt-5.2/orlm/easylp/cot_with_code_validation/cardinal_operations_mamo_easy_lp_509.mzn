% Parameters
int: budget = 1000;
int: rhs1 = 200;
int: rhs2 = 300;
int: rhs3 = -500;

int: c1 = 50;
int: c2 = 60;
int: c3 = 70;

% Variables
var 0..budget: x1;
var 0..budget: x2;
var 0..budget: x3;

% Constraints
constraint x1 + x2 + x3 <= budget;

constraint 2*x1 - 3*x2 >= rhs1;

% x1 - 0.5*x3 <= 300  <=>  2*x1 - x3 <= 600
constraint 2*x1 - x3 <= 2*rhs2;

% x2 - 2.5*x1 - x3 >= -500  <=>  2*x2 - 5*x1 - 2*x3 >= -1000
constraint 2*x2 - 5*x1 - 2*x3 >= 2*rhs3;

% Objective
solve minimize c1*x1 + c2*x2 + c3*x3;