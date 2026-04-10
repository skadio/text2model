% Parameters (with values embedded)
int: maxTotalUnits = 5000;

int: costX = 5;
int: costY = 10;
int: costZ = 20;

int: minExtraX = 1000;          % X >= 0.5*Y + 1000
int: zExtraLimit = 1500;        % Z <= 0.75*X + 1500

% Variables
var 0..maxTotalUnits: X;
var 0..maxTotalUnits: Y;
var 0..maxTotalUnits: Z;

var 0..(costX*maxTotalUnits + costY*maxTotalUnits + costZ*maxTotalUnits): totalCost;

% Constraints
constraint X + Y + Z <= maxTotalUnits;

% X must be at least 1000 more than half of Y:
% 2*X >= Y + 2000
constraint 2 * X >= Y + 2 * minExtraX;

% Z should not exceed 75% of X by more than 1500:
% Z <= 0.75*X + 1500  =>  4*Z <= 3*X + 6000
constraint 4 * Z <= 3 * X + 4 * zExtraLimit;

% Total cost definition
constraint totalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize totalCost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "min_total_cost=", show(totalCost), "\n"
];