% Parameters (with values embedded)
int: totalEmployees = 20;

int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

int: minX = 5;
int: minY = 3;
int: minZ = 2;

% Variables
var 0..totalEmployees: x; % employees on project X
var 0..totalEmployees: y; % employees on project Y
var 0..totalEmployees: z; % employees on project Z

var 0..(totalEmployees * max([costX, costY, costZ])): totalCost;

% Constraints
constraint x + y + z = totalEmployees;

constraint x >= minX;
constraint y >= minY;
constraint z >= minZ;

constraint totalCost = costX * x + costY * y + costZ * z;

% Objective
solve minimize totalCost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "minimum_total_cost=$", show(totalCost), "\n"
];