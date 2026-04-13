int: max_total_budget = 1000;

int: min_X = 200;
int: min_Y = 150;
int: min_Z = 50;

int: return_X = 2;
int: return_Y = 3;
int: return_Z = 1;

var min_X..max_total_budget: X;
var min_Y..max_total_budget: Y;
var min_Z..max_total_budget: Z;

constraint X + Y + Z <= max_total_budget;

% Objective: minimize total cost (total invested budget)
var 0..max_total_budget: total_cost = X + Y + Z;

solve minimize total_cost;

output [
  "X (Buying) = ", show(X), "\n",
  "Y (Marketing) = ", show(Y), "\n",
  "Z (Logistics) = ", show(Z), "\n",
  "Total cost = ", show(total_cost), "\n",
  "Total return = ", show(return_X*X + return_Y*Y + return_Z*Z), "\n"
];