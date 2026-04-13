% Parameters
int: maxXY = 200;                 % Maximum trucks allowed on routes X and Y combined
int: minYZ = 150;                 % Minimum trucks required on routes Y and Z combined
int: diffXZ = 30;                 % Required difference between trucks on X and Z (X - Z)

int: maxX = 100;                  % Upper bound for trucks on route X
int: maxY = 120;                  % Upper bound for trucks on route Y
int: maxZ = 90;                   % Upper bound for trucks on route Z

int: costX = 5;                   % Cost per truck on route X
int: costY = 4;                   % Cost per truck on route Y
int: costZ = 3;                   % Cost per truck on route Z

% Variables
var 0..maxX: trucksX;             % Number of trucks assigned to route X (integer)
var 0..maxY: trucksY;             % Number of trucks assigned to route Y (integer)
var 0..maxZ: trucksZ;             % Number of trucks assigned to route Z (integer)

var 0..(costX*maxX + costY*maxY + costZ*maxZ): totalCost;  % Total cost in dollars (integer)

% Constraints
% Total cost definition (linking decision variables to total cost)
constraint
  totalCost = costX * trucksX + costY * trucksY + costZ * trucksZ;

% Fleet availability constraint: trucks on routes X and Y combined cannot exceed maxXY
constraint
  trucksX + trucksY <= maxXY;

% Coverage constraint: trucks on routes Y and Z combined must be at least minYZ
constraint
  trucksY + trucksZ >= minYZ;

% Operational requirement: difference between trucks on X and Z is exactly diffXZ (X - Z)
constraint
  trucksX - trucksZ = diffXZ;

% Objective
solve minimize totalCost;