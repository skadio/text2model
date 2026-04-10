% Parameters (with values embedded)
int: budget = 500;
int: minX = 100;
int: minY = 50;
int: minZ = 30;

int: costX = 1000;
int: costY = 1500;
int: costZ = 2000;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

% Constraints
constraint X + Y + Z <= budget;
constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

% Objective
var int: total_cost = costX * X + costY * Y + costZ * Z;
solve minimize total_cost;

output ["Minimum total cost ($): ", show(total_cost), "\n",
        "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n"];