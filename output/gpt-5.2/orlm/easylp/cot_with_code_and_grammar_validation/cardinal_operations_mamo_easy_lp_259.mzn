% Parameters
int: costX = 5;
int: costY = 6;
int: costZ = 3;

int: capXY = 1000;
int: capYZ = 1200;
int: minDiffXZ = 200;

int: lbX = 0; int: ubX = 700;
int: lbY = 0; int: ubY = 500;
int: lbZ = 0; int: ubZ = 600;

% Variables
var lbX..ubX: X;
var lbY..ubY: Y;
var lbZ..ubZ: Z;

var int: total_cost;

% Constraints
constraint X + Y <= capXY;
constraint Y + Z <= capYZ;
constraint X - Z >= minDiffXZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;