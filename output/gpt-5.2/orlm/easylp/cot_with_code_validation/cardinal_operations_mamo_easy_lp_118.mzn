% Parameters
int: aX = 2;
int: aY = 3;
int: cap = 50;

int: min_total = 10;
int: diff_cap = 20;

int: costX = 100;
int: costY = 200;

% Variables
var 0..cap: X;
var 0..cap: Y;

var 0..(costX*cap + costY*cap): total_cost;

% Constraints
constraint aX * X + aY * Y <= cap;
constraint X + Y >= min_total;
constraint abs(X - Y) <= diff_cap;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;