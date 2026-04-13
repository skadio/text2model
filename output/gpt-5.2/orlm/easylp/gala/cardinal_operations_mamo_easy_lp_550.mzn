% Employee allocation to projects X, Y, Z with minimum staffing and cost minimization

% Data (embedded as required)
int: totalEmployees = 100;
int: minX = 30;
int: minY = 20;
int: minZ = 10;

int: costX = 5000;
int: costY = 7000;
int: costZ = 8000;

% Decision variables: number of employees on each project (integers)
var minX..totalEmployees: x;
var minY..totalEmployees: y;
var minZ..totalEmployees: z;

% All employees must be allocated
constraint x + y + z = totalEmployees;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y + costZ * z;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "minimum_total_cost = $", show(totalCost), "\n"
];