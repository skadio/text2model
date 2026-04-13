% Parameters
int: costX = 10;              % cost per unit of product X
int: costY = 15;              % cost per unit of product Y
int: costZ = 20;              % cost per unit of product Z

int: maxXY = 5000;            % maximum combined production of X and Y
int: maxYZ = 4000;            % maximum combined production of Y and Z
int: minXZ = 2000;            % minimum combined production of X and Z

% Variables
var 0..maxXY: prodX;                         % units produced of X (nonnegative integer)
var 0..min(maxXY, maxYZ): prodY;             % units produced of Y (nonnegative integer)
var 0..maxYZ: prodZ;                         % units produced of Z (nonnegative integer)

var 0..(costX*maxXY + costY*min(maxXY, maxYZ) + costZ*maxYZ): totalCost; % total cost (integer dollars)

% Constraints
% Resource capacity constraints
constraint prodX + prodY <= maxXY;  % X + Y cannot exceed maxXY
constraint prodY + prodZ <= maxYZ;  % Y + Z cannot exceed maxYZ

% Market demand constraint
constraint prodX + prodZ >= minXZ;  % X + Z must be at least minXZ

% Total cost definition
constraint totalCost = costX * prodX + costY * prodY + costZ * prodZ;

% Objective
solve minimize totalCost;