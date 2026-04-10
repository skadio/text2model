include "globals.mzn";

% Data (embedded from problem statement)
int: maxA = 6000;
int: maxP = 4000;
int: maxO = 3000;
int: maxF = 7000; % Offline marketing

int: costA = 5;
int: costP = 2;
int: costO = 3;
int: costF = 4;

% Decision variables (whole-number allocations)
var 0..maxA: A; % Advertising
var 0..maxP: P; % PR
var 0..maxO: O; % Online Marketing
var 0..maxF: F; % Offline Marketing

% Constraints
constraint A + P <= 10000;
constraint O + F >= 2000;

% Difference constraints
constraint abs(A - O) <= 5000;
constraint P - F >= -1000;

% Objective: minimize total cost
var int: totalCost = costA*A + costP*P + costO*O + costF*F;
solve minimize totalCost;

output [
  "Advertising = ", show(A), "\n",
  "PR = ", show(P), "\n",
  "Online = ", show(O), "\n",
  "Offline = ", show(F), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];