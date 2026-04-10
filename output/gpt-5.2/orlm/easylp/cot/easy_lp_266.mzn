% Parameters (with values embedded)
int: TotalEmployees = 100;
int: minX = 20;
int: minY = 15;
int: minZ = 10;

int: costX = 50;
int: costY = 80;
int: costZ = 30;

% Variables
var 0..TotalEmployees: x; % hires in department X
var 0..TotalEmployees: y; % hires in department Y
var 0..TotalEmployees: z; % hires in department Z

var 0..(TotalEmployees * max([costX,costY,costZ])): totalCost;

% Constraints
constraint x + y + z = TotalEmployees;

constraint x >= minX;
constraint y >= minY;
constraint z >= minZ;

constraint totalCost = costX * x + costY * y + costZ * z;

% Objective
solve minimize totalCost;