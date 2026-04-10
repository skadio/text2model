% Parameters
int: support_X = 1000;
int: support_Y = 2000;

int: strength_X = 5;
int: strength_Y = 10;
int: min_strength = 50000;

int: cap_X = 3;
int: cap_Y = 4;
int: max_cap = 30000;

int: min_diff = 1000;

% Variables
var 0..10000: X;
var 0..10000: Y;
var 0..30000000: total_support;

% Constraints
constraint strength_X * X + strength_Y * Y >= min_strength;
constraint cap_X * X + cap_Y * Y <= max_cap;
constraint X - Y >= min_diff;

constraint total_support = support_X * X + support_Y * Y;

% Objective
solve minimize total_support;