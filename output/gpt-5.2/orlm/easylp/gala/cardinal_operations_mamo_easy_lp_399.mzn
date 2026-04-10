% Military unit deployment: minimize total support points subject to constraints
include "globals.mzn";

% Decision variables: whole numbers of units
var 0..10: X;
var 0..10: Y;
var 0..20: Z;
var 0..20: W;

% Constraints
constraint X + Y <= 10;     % logistical limit for X and Y
constraint Z + W <= 20;     % logistical limit for Z and W
constraint X + Z >= 5;      % strategic requirement
constraint Y + W >= 7;      % strategic requirement

% Costs (support points)
int: cX = 1000;
int: cY = 2000;
int: cZ = 500;
int: cW = 1500;

var int: total_support = cX*X + cY*Y + cZ*Z + cW*W;

solve minimize total_support;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "TotalSupport=", show(total_support), "\n"
];