% Resource allocation across three projects: X, Y, Z

var 0..50: X;
var 0..30: Y;
var 0..100: Z; % implied upper bound from total allocation constraint

% Constraints
constraint X + Y + Z <= 100;
constraint X >= 2 * Y + 10;
constraint Y + Z <= 70;

% Costs per unit
int: costX = 3;
int: costY = 2;
int: costZ = 5;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];