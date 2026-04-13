% Parameters
int: maxX = 20;
int: maxY = 15;

int: a1 = 10;  % metric-1 coefficient for X
int: b1 = 15;  % metric-1 coefficient for Y
int: rhs1 = 100;

int: a2 = 20;  % metric-2 coefficient for X
int: b2 = 30;  % metric-2 coefficient for Y
int: rhs2 = 200;

int: diffXY = 10;

int: costX = 5000;
int: costY = 7000;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..(maxX*costX + maxY*costY): total_cost;

% Constraints
constraint a1 * X + b1 * Y >= rhs1;
constraint a2 * X + b2 * Y <= rhs2;
constraint X - Y >= diffXY;
constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;