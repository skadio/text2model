% Parameters
int: B = 500;          % total investment upper bound
int: reqXY = 400;      % requirement: 2*X + 3*Y >= reqXY
int: diffYZ = 150;     % |Y - Z| <= diffYZ
int: minXZ = 100;      % X - Z >= minXZ

int: cX = 50;
int: cY = 30;
int: cZ = 80;

% Variables
var 0..B: X;
var 0..B: Y;
var 0..B: Z;

var 0..(cX*B + cY*B + cZ*B): total_cost;

% Constraints
constraint X + Y + Z <= B;
constraint 2*X + 3*Y >= reqXY;
constraint abs(Y - Z) <= diffYZ;
constraint X - Z >= minXZ;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;