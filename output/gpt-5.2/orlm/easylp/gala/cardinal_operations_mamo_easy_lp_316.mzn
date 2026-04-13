include "globals.mzn";

% Data (embedded from the problem statement)
int: MAX_TOTAL = 1000;
int: MIN_STRENGTH = 400;      % 2*X + Y >= 400
int: MAX_YZ = 600;            % Y + Z <= 600

int: costX = 4;
int: costY = 3;
int: costZ = 5;

% Decision variables: whole-number resource allocations
var 0..MAX_TOTAL: X;
var 0..MAX_TOTAL: Y;
var 0..MAX_TOTAL: Z;

% Constraints
constraint X + Y + Z <= MAX_TOTAL;
constraint 2*X + Y >= MIN_STRENGTH;
constraint Y + Z <= MAX_YZ;

% Objective: minimize total cost
var 0..(costX*MAX_TOTAL + costY*MAX_TOTAL + costZ*MAX_TOTAL): totalCost;
constraint totalCost = costX*X + costY*Y + costZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(totalCost), "\n"
];