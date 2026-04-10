% Manufacturing production planning: minimize total cost

var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Capacity constraint
constraint X + Y + Z <= 1000;

% Demand constraint
constraint 3 * X + 4 * Y >= 600;

% Inventory balance constraint
constraint 5 * Z - Y <= 200;

% Objective: minimize total cost
var int: TotalCost = 50 * X + 30 * Y + 20 * Z;
solve minimize TotalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded to nearest dollar) = $", show(TotalCost), "\n"
];