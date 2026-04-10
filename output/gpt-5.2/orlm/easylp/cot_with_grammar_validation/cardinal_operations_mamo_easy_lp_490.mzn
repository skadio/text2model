% Parameters
int: aX = 10;
int: aY = 20;
int: cap = 3000;

int: bX = 3;
int: bY = 5;
int: req = 500;

int: diffMax = 1000;

int: cX = 10000;
int: cY = 20000;

% Variables
var 0..cap div aX: X;
var 0..cap div aY: Y;
var 0..(cX*(cap div aX) + cY*(cap div aY)): total_cost;

% Constraints
constraint aX * X + aY * Y <= cap;

constraint bX * X + bY * Y >= req;

constraint X - Y <= diffMax;
constraint Y - X <= diffMax;

constraint total_cost = cX * X + cY * Y;

% Objective
solve minimize total_cost;