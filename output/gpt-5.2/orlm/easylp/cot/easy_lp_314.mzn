% Parameters (with values embedded)
int: maxResources = 100;
int: minEffectiveness = 350;

int: effX = 5;
int: effY = 3;
int: effZ = 7;

int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

% Variables
var 0..maxResources: x; % resources for Operation X
var 0..maxResources: y; % resources for Operation Y
var 0..maxResources: z; % resources for Operation Z

var 0..(costX*maxResources + costY*maxResources + costZ*maxResources): totalCost;

% Constraints
constraint x + y + z <= maxResources;

constraint effX*x + effY*y + effZ*z >= minEffectiveness;

% "twice the number of resources allocated to Operations X and Y subtracted from those for operation Z should be non-negative"
constraint z - 2*x - 2*y >= 0;

constraint totalCost = costX*x + costY*y + costZ*z;

% Objective
solve minimize totalCost;