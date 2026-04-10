% Parameters
int: c1 = 10;
int: c2 = 15;
int: c3 = 20;

int: ub1 = 10000;
int: ub2 = 8000;
int: ub3 = 6000;

int: rhs1 = 5000;
int: rhs2 = 1500;
int: rhs3 = 2000;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;

var int: total_cost;

% Constraints
constraint 5*x1 + 7*x2 + 9*x3 >= rhs1;

constraint 3*x2 - x1 - 4*x3 <= rhs2;

% x1 - x3 - 2.5*x2 = 2000  <=>  2*x1 - 2*x3 - 5*x2 = 4000
constraint 2*x1 - 2*x3 - 5*x2 = 2*rhs3;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;