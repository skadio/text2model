% Parameters
int: c1 = 10;
int: c2 = 15;
int: c3 = 12;
int: c4 = 20;

int: ub12 = 8;   % x1 + x2 <= 8
int: ub34 = 10;  % x3 + x4 <= 10
int: lb13 = 5;   % x1 + x3 >= 5
int: lb24 = 6;   % x2 + x4 >= 6

% No specific individual bounds were provided in the description, so use non-negativity.
int: L = 0;
int: U = ub12 + ub34; % safe upper bound for each variable

% Variables
var L..U: x1;
var L..U: x2;
var L..U: x3;
var L..U: x4;

var 0..(c1*U + c2*U + c3*U + c4*U): fatigue;

% Constraints
constraint x1 + x2 <= ub12;
constraint x3 + x4 <= ub34;
constraint x1 + x3 >= lb13;
constraint x2 + x4 >= lb24;

constraint fatigue = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize fatigue;