% Workforce allocation among departments X, Y, Z
% Data embedded as required

int: maxTotal = 100;

int: minX = 20;
int: minY = 30;
int: minZ = 10;

int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

% Decision variables: number of employees in each department (integers)
var minX..maxTotal: x;
var minY..maxTotal: y;
var minZ..maxTotal: z;

% Total headcount constraint
constraint x + y + z <= maxTotal;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y + costZ * z;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "totalCost = ", show(totalCost), "\n"
];