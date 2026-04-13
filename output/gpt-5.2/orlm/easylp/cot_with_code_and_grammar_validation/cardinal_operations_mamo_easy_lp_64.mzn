% Parameters
int: costX = 500;
int: costY = 700;
int: perfReq = 2000;
int: maxTotalRes = 1500;

% Variables
var 0..maxTotalRes: x;
var 0..maxTotalRes: y;

% Constraints
constraint 2*x + 3*y >= perfReq;
constraint x + y <= maxTotalRes;

% Objective
solve minimize costX*x + costY*y;