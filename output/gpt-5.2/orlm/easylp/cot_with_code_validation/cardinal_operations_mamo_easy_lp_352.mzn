% Parameters
int: maxXY = 100;
int: maxZW = 80;
int: minXZ = 50;
int: minYW = 60;

% Costs as scaled integers (x10) to avoid floating point issues:
% 0.2->2, 0.3->3, 0.1->1, 0.4->4
int: cX = 2;
int: cY = 3;
int: cZ = 1;
int: cW = 4;

% Variables
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxZW: Z;
var 0..maxZW: W;

var 0..1000000: totalCostScaled;  % total cost * 10
var 0..1000000: totalCostCeil;    % ceil(total cost)

% Constraints
constraint X + Y <= maxXY;
constraint Z + W <= maxZW;

constraint X + Z >= minXZ;
constraint Y + W >= minYW;

constraint totalCostScaled = cX*X + cY*Y + cZ*Z + cW*W;

% totalCostCeil = ceil(totalCostScaled / 10)
constraint 10 * totalCostCeil >= totalCostScaled;
constraint 10 * (totalCostCeil - 1) < totalCostScaled;

% Objective
solve minimize totalCostScaled;