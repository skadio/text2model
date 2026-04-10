% Parameters (with values embedded)
int: c1 = 500;
int: c2 = 600;
int: c3 = 800;
int: c4 = 700;

int: cap12 = 100;
int: cap34 = 50;

% Specific bounds on each department's resource allocation (not provided in the description)
% Use non-negative integer allocations as explicit bounds.
int: UB1 = 100;
int: UB2 = 100;
int: UB3 = 50;
int: UB4 = 50;

% Variables
var 0..UB1: x1;
var 0..UB2: x2;
var 0..UB3: x3;
var 0..UB4: x4;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint x3 >= 2 * x1;
constraint 4 * x4 >= 3 * x2;   % x4 >= (3/4)*x2 without fractions

constraint (x3 + x4) - (x1 + x2) >= 30;

% Objective
solve minimize c1*x1 + c2*x2 + c3*x3 + c4*x4;