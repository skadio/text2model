int: BUDGET = 1000;

var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

constraint X + Y + Z <= BUDGET;

% "Project X requires a minimum excess of 200 units over twice Y"
constraint X >= 2 * Y + 200;

% "Project Z must be at least 100 units more than Y"
constraint Z >= Y + 100;

% Costs per unit for X, Y, Z
var int: total_cost = 2 * X + 3 * Y + 1 * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n"
];