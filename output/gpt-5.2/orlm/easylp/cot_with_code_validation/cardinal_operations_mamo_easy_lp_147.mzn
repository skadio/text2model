% Parameters
int: support_x = 50;
int: support_y = 75;

int: a1x = 2;
int: a1y = 1;
int: b1  = 60;

int: a2x = 1;
int: a2y = 3;
int: b2  = 120;

% Variables
var 0..b2: x;
var 0..b2: y;
var 0..(support_x*b2 + support_y*b2): total_support;

% Constraints
constraint x >= 0;
constraint y >= 0;

constraint a1x*x + a1y*y >= b1;
constraint a2x*x + a2y*y <= b2;

constraint total_support = support_x*x + support_y*y;

% Objective
solve minimize total_support;