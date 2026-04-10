% Parameters
int: Bmax = 5000;

int: rhs1 = 2000;  % 3X - Y + Z >= 2000
int: rhs2 = 1000;  % X - 2Y + Z >= -1000  (equiv to X - 2Y + Z + 1000 >= 0)
int: rhs3 = 1500;  % X - Y + 3Z >= 1500

int: cX = 60;
int: cY = 75;
int: cZ = 50;

% Variables
var 0..Bmax: X;
var 0..Bmax: Y;
var 0..Bmax: Z;

var 0..(cX*Bmax + cY*Bmax + cZ*Bmax): total_cost;

% Constraints
constraint X + Y + Z <= Bmax;

constraint 3*X - Y + Z >= rhs1;

% From: X - 2Y - Z <= 1000  =>  X - 2Y + Z >= -1000
constraint X - 2*Y + Z >= -rhs2;

constraint X - Y + 3*Z >= rhs3;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;