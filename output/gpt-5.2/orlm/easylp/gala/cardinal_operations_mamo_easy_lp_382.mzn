include "globals.mzn";

% Data (embedded from problem description)
int: maxX = 5;
int: maxY = 5;
int: maxZ = 6;
int: maxW = 6;

int: fatX = 2;
int: fatY = 3;
int: fatZ = 4;
int: fatW = 5;

int: capXY = 10;
int: capZW = 12;

int: minXZ = 6;
int: minYW = 8;

% Decision variables: integer training hours per group
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;
var 0..maxW: W;

% Constraints
constraint X + Y <= capXY;
constraint Z + W <= capZW;
constraint X + Z >= minXZ;
constraint Y + W >= minYW;

% Objective: minimize total fatigue score
var int: totalFatigue = fatX*X + fatY*Y + fatZ*Z + fatW*W;

solve minimize totalFatigue;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "Total fatigue (rounded) = ", show(totalFatigue), "\n"
];