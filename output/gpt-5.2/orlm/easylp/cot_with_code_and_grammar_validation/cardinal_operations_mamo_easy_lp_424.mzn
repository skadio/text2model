% Parameters
int: a1 = 10;
int: a2 = 15;
int: cap = 2000;

int: b1 = 12;
int: b2 = 6;
int: minprod = 800;

int: diff_ub = 100;

int: c1 = 50;
int: c2 = 75;

% Variables
var 0..cap: X1;
var 0..cap: X2;

% Constraints
constraint a1 * X1 + a2 * X2 <= cap;
constraint b1 * X1 + b2 * X2 >= minprod;

% X1 - 0.5*X2 <= 100  <=>  2*X1 - X2 <= 200
constraint 2 * X1 - X2 <= 2 * diff_ub;

% Objective
solve minimize c1 * X1 + c2 * X2;