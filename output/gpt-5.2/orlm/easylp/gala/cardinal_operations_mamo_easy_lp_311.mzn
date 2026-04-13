include "globals.mzn";

% Data (embedded from problem statement)
int: max_units = 1000;

int: req_strength = 200;     % 2*X + 1*Y >= 200
int: req_xz = 300;           % X + Z >= 300

int: costX = 300;
int: costY = 500;
int: costZ = 700;

% Decision variables: number of units (integers)
var 0..max_units: X;
var 0..max_units: Y;
var 0..max_units: Z;

% Constraints
constraint X + Y + Z <= max_units;
constraint 2*X + Y >= req_strength;
constraint X + Z >= req_xz;

% Objective: minimize total resource points
var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total resource points (rounded) = ", show(total_cost), "\n"
];