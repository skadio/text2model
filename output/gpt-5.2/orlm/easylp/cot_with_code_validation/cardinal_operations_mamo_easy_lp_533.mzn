% Parameters
int: c1 = 10;
int: c2 = 20;
int: c3 = 30;

int: rhs1 = 2000;
int: rhs2 = 1000;
int: rhs3 = 500;

% Variables
var int: X1;
var int: X2;
var int: X3;

var int: total_cost;

% Constraints
constraint X1 >= 0 /\ X2 >= 0 /\ X3 >= 0;

constraint X1 + 2 * X2 <= rhs1;
constraint 3 * X1 + 4 * X3 >= rhs2;
constraint X2 - 5 * X3 <= rhs3;

constraint total_cost = c1 * X1 + c2 * X2 + c3 * X3;

% Objective
solve minimize total_cost;