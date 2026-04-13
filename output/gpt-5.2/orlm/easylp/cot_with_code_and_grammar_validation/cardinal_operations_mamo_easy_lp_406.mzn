% Parameters
int: costX = 10;
int: costY = 15;
int: costZ = 20;
int: costW = 25;

int: capXY = 500;
int: capZW = 700;

int: minXZ = 200;
int: minYW = 300;

% Variables
var 0..capXY: X;
var 0..capXY: Y;
var 0..capZW: Z;
var 0..capZW: W;

var 0..(costX*capXY + costY*capXY + costZ*capZW + costW*capZW): total_cost;

% Constraints
constraint X + Y <= capXY;
constraint Z + W <= capZW;

constraint X + Z >= minXZ;
constraint Y + W >= minYW;

constraint total_cost = costX*X + costY*Y + costZ*Z + costW*W;

% Objective
solve minimize total_cost;