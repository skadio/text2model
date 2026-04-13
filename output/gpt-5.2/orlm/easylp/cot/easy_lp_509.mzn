% Parameters (with values embedded)
int: BUDGET = 1000;

int: c1 = 50;
int: c2 = 60;
int: c3 = 70;

% Variables
var 0..BUDGET: x1;
var 0..BUDGET: x2;
var 0..BUDGET: x3;

% Constraints
constraint x1 + x2 + x3 <= BUDGET;

% 2*x1 - 3*x2 >= 200
constraint 2*x1 - 3*x2 >= 200;

% x1 cannot exceed by more than 300 units, half of x3:
% x1 <= 0.5*x3 + 300  <=>  2*x1 <= x3 + 600
constraint 2*x1 <= x3 + 600;

% 2.5*x2 - x1 - x3 >= -500  <=>  5*x2 - 2*x1 - 2*x3 >= -1000
constraint 5*x2 - 2*x1 - 2*x3 >= -1000;

% Objective
solve minimize c1*x1 + c2*x2 + c3*x3;