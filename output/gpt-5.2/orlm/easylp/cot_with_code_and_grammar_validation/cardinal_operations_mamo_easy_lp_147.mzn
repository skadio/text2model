% Parameters
int: support_x = 50;
int: support_y = 75;

int: a1 = 2;   % coefficient of X in constraint 1
int: b1 = 1;   % coefficient of Y in constraint 1
int: rhs1 = 60;

int: a2 = 1;   % coefficient of X in constraint 2
int: b2 = 3;   % coefficient of Y in constraint 2
int: rhs2 = 120;

% Variables
var 0..rhs1: x;
var 0..rhs2: y;

% Constraints
constraint a1 * x + b1 * y >= rhs1;
constraint a2 * x + b2 * y <= rhs2;

% Objective
var int: total_support = support_x * x + support_y * y;
solve minimize total_support;