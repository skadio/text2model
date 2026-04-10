% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: ub12 = 100;
int: rhs2 = 50;
int: rhs3 = 20;
int: rhs4 = 10;

% Variables
var int: x1;
var int: x2;
var int: x3;
var int: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= ub12;
constraint 2 * x1 + x3 >= rhs2;
constraint x2 - 3 * x4 <= rhs3;
% Avoid fractions by multiplying by 2: x4 - 0.5*x1 >= 10  <=>  2*x4 - x1 >= 20
constraint 2 * x4 - x1 >= 2 * rhs4;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;