% Parameters (with values embedded)
int: maxShips = 1000;
int: minCapacity = 800;
int: maxDiff = 200;
int: costX = 8;
int: costY = 15;

% Variables
var 0..maxShips: X;
var 0..maxShips: Y;

% Constraints
constraint X + Y <= maxShips;
constraint 2 * X + Y >= minCapacity;
constraint X - (Y div 2) <= maxDiff;

% Objective
solve minimize costX * X + costY * Y;