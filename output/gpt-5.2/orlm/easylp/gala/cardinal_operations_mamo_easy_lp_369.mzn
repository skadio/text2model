include "globals.mzn";

% Data (embedded from the problem statement)
int: c1 = 150;
int: c2 = 200;
int: c3 = 300;
int: c4 = 400;

int: cap12 = 1000;
int: cap34 = 500;

int: req12 = 1200;   % 2*X1 + 3*X2 >= 1200
int: req34 = 2500;   % 5*X3 + 6*X4 >= 2500

% Decision variables: whole-number allocations
var 0..cap12: X1;
var 0..cap12: X2;
var 0..cap34: X3;
var 0..cap34: X4;

% Capacity constraints
constraint X1 + X2 <= cap12;
constraint X3 + X4 <= cap34;

% Effectiveness constraints
constraint 2*X1 + 3*X2 >= req12;
constraint 5*X3 + 6*X4 >= req34;

% Objective: minimize total cost
var int: total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

solve minimize total_cost;

output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "X3 = ", show(X3), "\n",
  "X4 = ", show(X4), "\n",
  "TotalCost = $", show(total_cost), "\n"
];