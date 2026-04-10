% Budget distribution among departments X, Y, Z
% Minimize total cost (total budget spent) while meeting minimum investments
% and staying within the overall budget limit.

int: max_total_budget = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 50;

int: retX = 2;
int: retY = 3;
int: retZ = 1;

% Decision variables: whole-number investments
var minX..max_total_budget: X;
var minY..max_total_budget: Y;
var minZ..max_total_budget: Z;

% Total spent
var 0..max_total_budget: total_cost = X + Y + Z;

% Constraints
constraint total_cost <= max_total_budget;

% (Returns are defined for completeness; not constrained by the description)
var 0..(retX+retY+retZ)*max_total_budget: total_return = retX*X + retY*Y + retZ*Z;

solve minimize total_cost;

output [
  "X (Buying) = ", show(X), "\n",
  "Y (Marketing) = ", show(Y), "\n",
  "Z (Logistics) = ", show(Z), "\n",
  "Total cost = ", show(total_cost), "\n",
  "Total return = ", show(total_return), "\n"
];