% Parameters
int: maxX = 30;
int: maxY = 20;

int: a1 = 5;
int: b1 = 3;
int: rhs1 = 200;

int: a2 = 10;
int: b2 = 15;
int: rhs2 = 300;

int: diffMax = 50;

int: costX = 10000;
int: costY = 15000;

% Variables
var 0..maxX: x;
var 0..maxY: y;

var 0..(costX * maxX + costY * maxY): total_cost;

% Constraints
constraint a1 * x + b1 * y <= rhs1;
constraint a2 * x + b2 * y >= rhs2;
constraint abs(x - y) <= diffMax;

constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;