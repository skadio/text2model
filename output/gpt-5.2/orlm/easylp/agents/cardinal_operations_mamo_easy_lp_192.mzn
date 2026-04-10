% Parameters
int: costX = 5;                 % operating cost per day for vehicle type X ($/day)
int: costY = 7;                 % operating cost per day for vehicle type Y ($/day)
int: costZ = 3;                 % operating cost per day for vehicle type Z ($/day)

int: maxTotalVehicles = 50;     % maximum total vehicles operated per day
int: minXMinusY = 10;           % requirement: X >= Y + 10
int: maxYPlusZ = 40;            % limitation: Y + Z <= 40

int: maxX = 20;                 % fleet size max for X
int: maxY = 30;                 % fleet size max for Y
int: maxZ = 25;                 % fleet size max for Z

% Variables
var 0..maxX: numX;              % number of type X vehicles operated (integer)
var 0..maxY: numY;              % number of type Y vehicles operated (integer)
var 0..maxZ: numZ;              % number of type Z vehicles operated (integer)

var 0..(costX*maxX + costY*maxY + costZ*maxZ): totalCost;  % total daily operating cost ($)

% Constraints
% Total vehicles operated cannot exceed staffing limit
constraint
  numX + numY + numZ <= maxTotalVehicles;

% Service requirement: type X vehicles must be at least minXMinusY more than type Y
constraint
  numX >= numY + minXMinusY;

% Maintenance facility limitation: combined type Y and Z vehicles cannot exceed maxYPlusZ
constraint
  numY + numZ <= maxYPlusZ;

% Define total daily operating cost from vehicle counts and per-day costs
constraint
  totalCost = costX * numX + costY * numY + costZ * numZ;

% Objective
solve minimize totalCost;