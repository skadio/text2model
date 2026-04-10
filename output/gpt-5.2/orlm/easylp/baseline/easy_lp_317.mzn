% Resource allocation for routes X, Y, Z (integer units)
var 0..100: X;
var 0..100: Y;
var 0..100: Z;

% Constraints
constraint X + Y + Z <= 100;
constraint X >= Y + 10;
constraint Y + Z <= 70;

% Cost per unit
int: cX = 5;
int: cY = 3;
int: cZ = 4;

% Objective: minimize total cost
var int: total_cost = cX * X + cY * Y + cZ * Z;
solve minimize total_cost;

% Output (minimum cost is already integral, so "rounded" is the same)
output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];