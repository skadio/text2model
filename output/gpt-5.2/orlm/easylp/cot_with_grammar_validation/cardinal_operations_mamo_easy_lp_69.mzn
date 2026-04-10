% Parameters
int: costX = 5;
int: costY = 10;

int: minQuota = 200;         % 2*X + Y >= 200
int: maxCapacity = 150;      % X + 3*Y <= 150

% Variable bounds (derived)
int: maxX = 150;             % from X + 3Y <= 150 and Y >= 0
int: maxY = 50;              % from X + 3Y <= 150 and X >= 0

% Variables
var 0..maxX: X;
var 0..maxY: Y;

var 0..(costX*maxX + costY*maxY): totalCost;

% Constraints
constraint 2*X + Y >= minQuota;
constraint X + 3*Y <= maxCapacity;

constraint totalCost = costX*X + costY*Y;

% Objective
solve minimize totalCost;