% Parameters
int: costX = 5;
int: costY = 4;
int: costZ = 6;

int: min_expr1 = 10; % 2X + 3Y + Z >= 10
int: max_expr2 = 8;  % X - Y + Z <= 8
int: min_expr3 = 3;  % Y - Z >= 3

% Variables
var 0..100: X;
var 0..100: Y;
var 0..100: Z;

var 0..10000: total_cost;

% Constraints
constraint 2*X + 3*Y + Z >= min_expr1;
constraint X - Y + Z <= max_expr2;
constraint Y - Z >= min_expr3;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;