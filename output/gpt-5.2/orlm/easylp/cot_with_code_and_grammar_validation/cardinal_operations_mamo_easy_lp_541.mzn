% Parameters
int: max_total = 1000;
int: c1 = 500;
int: c2 = 600;
int: c3 = 700;

% Variables
var 0..max_total: X1;
var 0..max_total: X2;
var 0..max_total: X3;

% Constraints
constraint X1 + X2 + X3 <= max_total;

% 2*X1 - 0.5*X2 >= 200  <=>  4*X1 - X2 >= 400
constraint 4 * X1 - X2 >= 400;

% 2*X3 - X1 <= 300
constraint 2 * X3 - X1 <= 300;

% Objective
solve minimize c1 * X1 + c2 * X2 + c3 * X3;