% Parameters
int: totalResourceLimit = 1000;          % Total resources available across X, Y, Z
int: minXMoreThanTwiceY = 100;           % X must be at least (2*Y + 100)
int: maxDiffYandZ = 50;                  % |Y - Z| must not exceed 50
int: minXplusZ = 300;                    % X + Z must be at least 300

int: costX = 2;                          % Cost per unit for initiative X
int: costY = 3;                          % Cost per unit for initiative Y
int: costZ = 4;                          % Cost per unit for initiative Z

int: minX = 0;                           % Lower bound for X
int: maxX = totalResourceLimit;          % Upper bound for X
int: minY = 0;                           % Lower bound for Y
int: maxY = totalResourceLimit;          % Upper bound for Y
int: minZ = 0;                           % Lower bound for Z
int: maxZ = totalResourceLimit;          % Upper bound for Z

% Variables
var minX..maxX: X;                       % Resource allocation to initiative X
var minY..maxY: Y;                       % Resource allocation to initiative Y
var minZ..maxZ: Z;                       % Resource allocation to initiative Z

var int: totalCost;                      % Total cost to minimize

% Constraints
% Resource availability: total allocation must respect the overall limit
constraint
  X + Y + Z <= totalResourceLimit;

% Initiative X must be at least 100 units more than twice initiative Y
constraint
  X >= 2 * Y + minXMoreThanTwiceY;

% Balance between initiatives Y and Z: their difference must be within the allowed range
constraint
  abs(Y - Z) <= maxDiffYandZ;

% Minimum combined commitment to initiatives X and Z
constraint
  X + Z >= minXplusZ;

% Define total cost from unit costs and allocations
constraint
  totalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize totalCost;