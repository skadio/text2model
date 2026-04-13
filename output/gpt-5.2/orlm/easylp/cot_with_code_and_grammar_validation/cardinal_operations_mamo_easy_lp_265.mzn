% Parameters
int: totalBudget = 100000;
int: minX = 30000;
int: minY = 20000;
int: minZ = 10000;

% Costs per employee (dollars)
int: costX = 5000;
int: costY = 3000;
int: costZ = 2000;

% Budgets must be multiples of 1000 dollars
int: step = 1000;

% Variables
var 0..totalBudget div step: xk; % budget for X in thousands
var 0..totalBudget div step: yk; % budget for Y in thousands
var 0..totalBudget div step: zk; % budget for Z in thousands

var 0..totalBudget: x;
var 0..totalBudget: y;
var 0..totalBudget: z;

var 0..(costX*(totalBudget div step) + costY*(totalBudget div step) + costZ*(totalBudget div step)): totalCost;

% Constraints
constraint x = step * xk;
constraint y = step * yk;
constraint z = step * zk;

constraint x + y + z <= totalBudget;

constraint x >= minX;
constraint y >= minY;
constraint z >= minZ;

constraint totalCost = costX * xk + costY * yk + costZ * zk;

% Objective
solve minimize totalCost;