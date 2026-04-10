% Military resource allocation (embedded data)
include "globals.mzn";

% Parameters (from description)
int: Rmax = 1000;
int: rT = 5;   int: rA = 3;   int: rS = 2;

int: strengthMin = 200;
int: cT = 30;  int: cA = 20;  int: cS = 10;

int: diffTarget = 50;

% Decision variables: counts of units (nonnegative integers)
var 0..Rmax div rT: Tanks;
var 0..Rmax div rA: Aircrafts;
var 0..Rmax div rS: Submarines;

% Constraints
constraint rT*Tanks + rA*Aircrafts + rS*Submarines <= Rmax;

constraint 2*Tanks + 4*Aircrafts + Submarines >= strengthMin;

% "difference between Tanks and Aircrafts plus Submarines equals 50"
constraint Tanks - (Aircrafts + Submarines) = diffTarget;

% Objective: minimize operational costs
var int: totalCost = cT*Tanks + cA*Aircrafts + cS*Submarines;

solve minimize totalCost;

output [
  "Tanks = ", show(Tanks), "\n",
  "Aircrafts = ", show(Aircrafts), "\n",
  "Submarines = ", show(Submarines), "\n",
  "Minimum cost = $", show(totalCost), "\n"
];