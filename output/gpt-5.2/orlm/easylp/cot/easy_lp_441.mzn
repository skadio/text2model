% Parameters (with values embedded)
int: costX = 20;
int: costY = 30;

int: maxTotalInventory = 500;
int: minCombinedEffect = 1000;

int: maxX = 400;
int: maxY = 300;

int: diffLimit = 600; % "four times X should not exceed by more than 600 from Y" -> 4*X - Y <= 600

% Variables
var 0..maxX: x; % inventory units of category X (integer)
var 0..maxY: y; % inventory units of category Y (integer)

var 0..(costX*maxX + costY*maxY): totalCost;

% Constraints
constraint x + y <= maxTotalInventory;
constraint 3*x + 2*y >= minCombinedEffect;
constraint 4*x - y <= diffLimit;

constraint totalCost = costX*x + costY*y;

% Objective
solve minimize totalCost;