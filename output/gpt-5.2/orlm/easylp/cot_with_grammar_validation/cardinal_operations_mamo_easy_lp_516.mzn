% Parameters
int: CAP = 2000;
int: D1 = 1000;
int: D2 = 500;
int: cX = 3;
int: cY = 2;
int: cZ = 1;

% Variables
var 0..CAP: X;
var 0..CAP: Y;
var 0..CAP: Z;
var 0..(cX*CAP + cY*CAP + cZ*CAP): total_cost;

% Constraints
constraint X + Y + Z <= CAP;

constraint abs(X - 2*Y) >= D1;
constraint abs(Z - Y) >= D2;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;