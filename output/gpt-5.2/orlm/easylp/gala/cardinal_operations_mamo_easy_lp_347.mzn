include "globals.mzn";

% Data (embedded)
int: total = 10_000_000;

int: minX = 2_000_000;
int: maxY = 5_000_000;
int: minZ = 1_500_000;
int: maxW = 3_000_000;

% Returns per dollar invested, represented exactly as rational (percent / 100)
% X=5%, Y=7%, Z=6%, W=8%
int: rX = 5;
int: rY = 7;
int: rZ = 6;
int: rW = 8;

% Decision variables: whole-dollar allocations
var 0..total: X;
var 0..total: Y;
var 0..total: Z;
var 0..total: W;

% Constraints
constraint X + Y + Z + W = total;
constraint X >= minX;
constraint Y <= maxY;
constraint Z >= minZ;
constraint W <= maxW;

% Objective: minimize total return (in dollars).
% Since return = sum(allocation * rate)/100, minimize numerator then divide.
var 0..100*total: ret_num = rX*X + rY*Y + rZ*Z + rW*W; % return * 100

solve minimize ret_num;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "W = ", show(W), "\n",
  "Minimum total return (rounded to nearest dollar) = ",
  show( (ret_num + 50) div 100 ), "\n"
];