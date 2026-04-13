% Portfolio investment minimization (all data embedded)

% Decision variables: integer investment amounts in dollars
var 0..1000: x;  % Asset X
var 0..1000: y;  % Asset Y
var 0..1000: z;  % Asset Z

% Data
int: budget = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 250;

int: costX = 500;
int: costY = 300;
int: costZ = 700;

% Constraints
constraint x + y + z <= budget;
constraint x >= minX;
constraint y >= minY;
constraint z >= minZ;

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];