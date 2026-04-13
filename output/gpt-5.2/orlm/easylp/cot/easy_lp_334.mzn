% Parameters (with values embedded)
int: maxXY = 5000;
int: maxZW = 2000;

int: diffXZ = 1000;
int: diffYW = 1500;

int: maxX = 4000;
int: maxY = 3000;
int: minZ = 500;
int: minW = 200;

int: costX = 20;
int: costY = 30;
int: costZ = 50;
int: costW = 10;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..(maxZW): Z;
var 0..(maxZW): W;

% Constraints
constraint X + Y <= maxXY;
constraint Z + W <= maxZW;

constraint X - Z >= diffXZ;
constraint Y - W >= diffYW;

constraint Z >= minZ;
constraint W >= minW;

% Objective
var int: total_cost = costX*X + costY*Y + costZ*Z + costW*W;
solve minimize total_cost;