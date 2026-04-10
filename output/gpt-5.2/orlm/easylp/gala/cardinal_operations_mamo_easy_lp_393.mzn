include "globals.mzn";

% Data (embedded as required)
int: costT = 500;
int: costP = 300;
int: costS = 200;
int: costR = 100;

% Decision variables (whole number of units)
var 0..50: T;   % Technology
var 0..50: P;   % Physics
var 0..30: S;   % Sports
var 0..30: R;   % Research

% Constraints
constraint T + P <= 50;
constraint S + R <= 30;

constraint T >= 15;
constraint P >= 10;
constraint S >= 5;
constraint R >= 2;

% Objective: minimize total cost
var int: totalCost = costT*T + costP*P + costS*S + costR*R;

solve minimize totalCost;

output [
  "T = ", show(T), "\n",
  "P = ", show(P), "\n",
  "S = ", show(S), "\n",
  "R = ", show(R), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];