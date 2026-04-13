% Supply chain allocation optimization (all data embedded)

% Decision variables: integer allocations
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Total allocation cannot exceed 1000
constraint X + Y + Z <= 1000;

% Viability constraints
constraint X >= Y + 200;
constraint Z >= Y + 50;

% Cost coefficients
int: cX = 4;
int: cY = 5;
int: cZ = 6;

% Objective: minimize total cost
var 0..10000000: totalCost = cX*X + cY*Y + cZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (nearest whole number) = ", show(totalCost), "\n"
];