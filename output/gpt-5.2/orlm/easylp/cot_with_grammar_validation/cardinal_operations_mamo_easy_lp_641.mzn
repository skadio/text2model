% Parameters
int: c1 = 100;
int: c2 = 150;
int: c3 = 80;
int: c4 = 50;

int: b1 = 5000;   % for constraint 1 RHS
int: b2 = 2000;   % for constraint 2 RHS
int: b3 = 4000;   % for constraint 3 RHS
int: b4 = 3000;   % for constraint 4 RHS

% scale all fractional coefficients by 2 to keep integrality (7.5=15/2, 8.5=17/2)
int: scale = 2;

% Variables
var int: x1;
var int: x2;
var int: x3;
var int: x4;

% Objective variable (bounded)
var 0..100000000: total_cost;

% Constraints
constraint x1 >= 0 /\ x2 >= 0 /\ x3 >= 0 /\ x4 >= 0;

constraint 3*x1 + 2*x2 - x3 <= b1;

constraint -x1 + 4*x2 + x4 >= b2;

constraint -x1 - x2 + 5*x3 - x4 = b3;

constraint scale*(6*x2 - x1) + 15*x3 - 17*x4 <= scale*b4;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;