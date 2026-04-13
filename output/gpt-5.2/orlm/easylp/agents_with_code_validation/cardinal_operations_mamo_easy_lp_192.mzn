% Parameters
% Operating costs per day (USD)
int: costX = 5;          % Vehicle type X
int: costY = 7;          % Vehicle type Y
int: costZ = 3;          % Vehicle type Z

% Operational constraints
int: maxTotalVehicles = 50;  % Staffing constraint: total vehicles per day
int: minXMinusY = 10;        % Service requirement: X >= Y + 10
int: maxYPlusZ = 40;         % Maintenance limit: Y + Z <= 40

% Fleet size limits (per vehicle type)
int: maxX = 20;
int: maxY = 30;
int: maxZ = 25;


% Variables
% Number of vehicles operated (integers by domain definition)
var 0..maxX: xVehicles;
var 0..maxY: yVehicles;
var 0..maxZ: zVehicles;

% Total daily operating cost (bounded by max possible cost)
var 0..(costX*maxX + costY*maxY + costZ*maxZ): totalCost;


% Constraints
% Total operated vehicles limited by staffing
constraint xVehicles + yVehicles + zVehicles <= maxTotalVehicles;

% Service requirement: X must be at least 10 more than Y
constraint xVehicles >= yVehicles + minXMinusY;

% Maintenance limitation: Y + Z cannot exceed 40
constraint yVehicles + zVehicles <= maxYPlusZ;

% Define total cost
constraint totalCost = costX * xVehicles + costY * yVehicles + costZ * zVehicles;


% Objective
solve minimize totalCost;