% Military resource allocation MILP (integer optimization)

include "globals.mzn";

% Parameters (embedded from problem statement)
int: max_units = 10000;
int: min_effectiveness = 20000;

int: effX = 5;
int: effY = 3;
int: effZ = 7;

int: costX = 500;
int: costY = 300;
int: costZ = 700;

% Decision variables: number of units of each type (whole numbers)
var 0..max_units: X;
var 0..max_units: Y;
var 0..max_units: Z;

% Constraints
constraint X + Y + Z <= max_units;
constraint effX * X + effY * Y + effZ * Z >= min_effectiveness;
constraint X >= Y;
constraint Z <= Y;

% Objective: minimize total cost
var 0..(costX*max_units + costY*max_units + costZ*max_units): total_cost =
  costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total cost = $", show(total_cost), "\n"
];