include "globals.mzn";

% Data (embedded as required)
int: maxX1 = 3000;
int: maxX2 = 2500;
int: maxX3 = 1500;

int: budgetMax = 5000;

% Costs per unit
int: c1 = 50;
int: c2 = 75;
int: c3 = 60;

% Decision variables: whole-number allocations
var 0..maxX1: X1;
var 0..maxX2: X2;
var 0..maxX3: X3;

% Constraints
constraint X1 + X2 + X3 <= budgetMax;

% Effectiveness: 0.5*X1 + 0.4*X2 + 0.6*X3 >= 2000
% Multiply by 10 to avoid fractions: 5*X1 + 4*X2 + 6*X3 >= 20000
constraint 5*X1 + 4*X2 + 6*X3 >= 20000;

% Balance constraint: |2*X2 - (X1 + X3)| <= 100
constraint abs(2*X2 - (X1 + X3)) <= 100;

% Objective: minimize total cost
var int: totalCost = c1*X1 + c2*X2 + c3*X3;

solve minimize totalCost;

output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "X3 = ", show(X3), "\n",
  "TotalCost = ", show(totalCost), "\n"
];