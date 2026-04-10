% Parameters
int: B = 1000;
int: minX = 0;
int: maxX = 1000;
int: minY = 0;
int: maxY = 1000;
int: minZ = 0;
int: maxZ = 1000;

int: cX = 50;
int: cY = 30;
int: cZ = 20;

int: deltaX = 200;   % X >= 2*Y + 200
int: deltaZ = 150;   % Z >= Y + 150

% Variables
var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

var 0..(cX*maxX + cY*maxY + cZ*maxZ): total_cost;

% Constraints
constraint X + Y + Z <= B;

constraint X >= 2*Y + deltaX;
constraint Z >= Y + deltaZ;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;