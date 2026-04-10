% Parameters
int: a1 = 10;
int: b1 = 20;
int: c1 = 3000;

int: a2 = 3;
int: b2 = 5;
int: c2 = 500;

int: diff_max = 1000;

int: costX = 10000;
int: costY = 20000;

% Variables
var 0..300: X;
var 0..150: Y;
var 0..6000000: total_cost;

% Constraints
constraint a1 * X + b1 * Y <= c1;
constraint a2 * X + b2 * Y >= c2;

constraint X - Y <= diff_max;
constraint Y - X <= diff_max;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;