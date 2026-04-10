% Parameters (with values embedded)
int: costX = 50;
int: costY = 60;
int: costZ = 70;

int: minX = 0;  int: maxX = 200;
int: minY = 0;  int: maxY = 150;
int: minZ = 0;  int: maxZ = 300;

% Variables
var minX..maxX: x;
var minY..maxY: y;
var minZ..maxZ: z;

var 0..(costX*maxX + costY*maxY + costZ*maxZ): total_cost;

% Constraints
constraint 2*x + 3*y + z >= 500;
constraint x + y + 4*z <= 800;
constraint x - y + z >= 100;

constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;