% Parameters
int: costX = 50;                 % Cost per container of type X (dollars)
int: costY = 70;                 % Cost per container of type Y (dollars)
int: maxContainers = 1000;       % Maximum total containers per trip
int: minX = 300;                 % Minimum required containers of type X
int: minY = 200;                 % Minimum required containers of type Y

% Variables
var minX..maxContainers: numX;   % Number of type X containers shipped (integer)
var minY..maxContainers: numY;   % Number of type Y containers shipped (integer)
var int: totalCost;              % Total shipping cost (dollars, integer)

% Constraints
% Enforce ship capacity limit on total number of containers
constraint numX + numY <= maxContainers;

% Define total cost based on shipped quantities and per-container costs
constraint totalCost = costX * numX + costY * numY;

% Objective
solve minimize totalCost;