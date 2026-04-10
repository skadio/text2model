% Parameters
int: maxXY = 200;              % Maximum trucks on routes X+Y
int: minYZ = 150;              % Minimum trucks on routes Y+Z
int: diffXZ = 30;              % Required difference X - Z

int: maxX = 100;               % Upper bound on trucks for route X
int: maxY = 120;               % Upper bound on trucks for route Y
int: maxZ = 90;                % Upper bound on trucks for route Z

int: costX = 5;                % Cost per truck on route X (dollars)
int: costY = 4;                % Cost per truck on route Y (dollars)
int: costZ = 3;                % Cost per truck on route Z (dollars)

% Variables
var 0..maxX: trucksX;          % Number of trucks assigned to route X
var 0..maxY: trucksY;          % Number of trucks assigned to route Y
var 0..maxZ: trucksZ;          % Number of trucks assigned to route Z

% Upper bound is a safe linear bound from maximum allocations
var 0..(costX*maxX + costY*maxY + costZ*maxZ): totalCost;  % Total cost (dollars)

% Constraints
% Fleet availability limit on combined routes X and Y
constraint trucksX + trucksY <= maxXY;

% Minimum coverage requirement on combined routes Y and Z
constraint trucksY + trucksZ >= minYZ;

% Operational requirement: exact difference between routes X and Z
constraint trucksX - trucksZ = diffXZ;

% Total cost calculation (linear expression)
constraint totalCost = costX * trucksX + costY * trucksY + costZ * trucksZ;

% Objective
solve minimize totalCost;