% Parameters
int: CAP = 500;

int: costX = 50;
int: costY = 60;
int: costZ = 20;

int: minX = 0; int: maxX = 300;
int: minY = 0; int: maxY = 200;
int: minZ = 0; int: maxZ = 100;

int: demand1 = 200; % 2*X + Y >= 200
int: demand2 = 150; % Y + Z >= 150

% Variables
var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

var 0..(costX*maxX + costY*maxY + costZ*maxZ): total_cost;

% Constraints
constraint X + Y + Z <= CAP;

constraint 2*X + Y >= demand1;
constraint Y + Z >= demand2;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;