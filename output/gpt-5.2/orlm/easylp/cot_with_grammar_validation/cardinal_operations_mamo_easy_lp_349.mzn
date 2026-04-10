% Parameters
int: costX = 30;
int: costY = 20;
int: costZ = 40;
int: costW = 50;

int: minXY = 100;
int: maxZW = 200;
int: minXZ = 150;
int: maxDiffYW = 50;

% Variables
var 0..1000000: X;
var 0..1000000: Y;
var 0..1000000: Z;
var 0..1000000: W;

var 0..100000000: total_cost;

% Constraints
constraint X + Y >= minXY;
constraint Z + W <= maxZW;
constraint X + Z >= minXZ;
constraint abs(Y - W) <= maxDiffYW;

constraint total_cost = costX * X + costY * Y + costZ * Z + costW * W;

% Objective
solve minimize total_cost;