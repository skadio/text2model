include "globals.mzn";

% Decision variables: acres (whole numbers)
var 0..500: X;
var 0..500: Y;
var 0..500: Z;

% Constraints
constraint X + Y + Z <= 500;

% Diversity/yield requirement
constraint 2*X + Y >= 200;

% Balance between Y and Z
constraint abs(Y - Z) <= 50;

% "X must be at least twice that of half of Z's area by at least 100 acres"
% Interpreting: X >= 2*(Z/2) + 100 = Z + 100
constraint X >= Z + 100;

% Cost per acre
int: cX = 100;
int: cY = 50;
int: cZ = 75;

var int: total_cost = cX*X + cY*Y + cZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];