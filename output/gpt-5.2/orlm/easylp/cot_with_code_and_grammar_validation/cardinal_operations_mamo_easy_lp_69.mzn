% Parameters
int: costX = 5;
int: costY = 10;

int: a1X = 2;
int: a1Y = 1;
int: rhs1 = 200; % 2*X + 1*Y >= 200

int: a2X = 1;
int: a2Y = 3;
int: rhs2 = 150; % 1*X + 3*Y <= 150

% Variables
var 0..200: X;
var 0..150: Y;
var 0..2500: total_cost;

% Constraints
constraint a1X * X + a1Y * Y >= rhs1;
constraint a2X * X + a2Y * Y <= rhs2;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;