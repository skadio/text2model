% Tourism package allocation - cost minimization
include "globals.mzn";

% Data (embedded from description)
int: MAX_TOTAL = 500;
int: MIN_XY = 200;
int: DIFF_YZ = 150;

int: costX = 50;
int: costY = 30;
int: costZ = 100;

% Decision variables (whole numbers)
var 0..MAX_TOTAL: X;
var 0..MAX_TOTAL: Y;
var 0..MAX_TOTAL: Z;

% Constraints
constraint X + Y + Z <= MAX_TOTAL;
constraint 2 * X >= Y;                 % X not less than half of Y  => X >= Y/2
constraint abs(Y - Z) <= DIFF_YZ;      % |Y - Z| <= 150
constraint X + Y >= MIN_XY;            % minimum service requirement

% Objective: minimize total cost
var int: TotalCost = costX * X + costY * Y + costZ * Z;

solve minimize TotalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(TotalCost), "\n"
];