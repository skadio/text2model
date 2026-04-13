% Parameters
int: cost1 = 2;
int: cost2 = 3;
int: cost3 = 4;
int: cost4 = 5;

int: x1_min = 100;
int: x1_max = 800;
int: x2_min = 50;
int: x2_max = 600;
int: x3_min = 20;
int: x3_max = 400;
int: x4_min = 40;
int: x4_max = 200;

% Variables
var x1_min..x1_max: X1;
var x2_min..x2_max: X2;
var x3_min..x3_max: X3;
var x4_min..x4_max: X4;

var 0..(cost1*x1_max + cost2*x2_max + cost3*x3_max + cost4*x4_max): TotalCost;

% Constraints
constraint
  TotalCost = cost1*X1 + cost2*X2 + cost3*X3 + cost4*X4;

% (1) 2*X2 - X1 - X3 + X4 >= 1000
constraint
  2*X2 - X1 - X3 + X4 >= 1000;

% (2) X1 + X3 <= 0.5*X2 + 0.7*X4 + 500
% Multiply by 10 to avoid fractions: 10X1 + 10X3 <= 5X2 + 7X4 + 5000
constraint
  10*X1 + 10*X3 <= 5*X2 + 7*X4 + 5000;

% (3) 0.8*X1 + X3 - 0.9*X2 <= 1500
% Multiply by 10: 8X1 + 10X3 - 9X2 <= 15000
constraint
  8*X1 + 10*X3 - 9*X2 <= 15000;

% (4) X1 + X2 + X3 + X4 >= 200
constraint
  X1 + X2 + X3 + X4 >= 200;

% (5) X1 + X3 - (3/5)*X2 <= 300
% Multiply by 5: 5X1 + 5X3 - 3X2 <= 1500
constraint
  5*X1 + 5*X3 - 3*X2 <= 1500;

% Objective
solve minimize TotalCost;