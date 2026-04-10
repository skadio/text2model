% Parameters
int: support_X = 50;
int: support_Y = 75;

int: a1_X = 2;
int: a1_Y = 1;
int: rhs1 = 60; % >=

int: a2_X = 1;
int: a2_Y = 3;
int: rhs2 = 120; % <=

% Variables
var 0..rhs1: x;
var 0..rhs2: y;

var int: total_support;

% Constraints
constraint a1_X * x + a1_Y * y >= rhs1;
constraint a2_X * x + a2_Y * y <= rhs2;

constraint total_support = support_X * x + support_Y * y;

% Objective
solve minimize total_support;