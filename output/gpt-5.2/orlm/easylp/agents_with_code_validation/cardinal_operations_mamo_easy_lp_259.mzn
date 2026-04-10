% Parameters
int: costX = 5;                 % Transportation cost per unit for center X
int: costY = 6;                 % Transportation cost per unit for center Y
int: costZ = 3;                 % Transportation cost per unit for center Z

int: capXY = 1000;              % Capacity limit for combined allocation of X and Y
int: capYZ = 1200;              % Capacity limit for combined allocation of Y and Z
int: minDiffXZ = 200;           % Minimum required difference between allocation of X and Z (X - Z >= 200)

int: minX = 0;  int: maxX = 700; % Bounds for allocation at center X
int: minY = 0;  int: maxY = 500; % Bounds for allocation at center Y
int: minZ = 0;  int: maxZ = 600; % Bounds for allocation at center Z

% Variables
var minX..maxX: allocX;         % Resource allocation to center X (integer units)
var minY..maxY: allocY;         % Resource allocation to center Y (integer units)
var minZ..maxZ: allocZ;         % Resource allocation to center Z (integer units)

var int: totalCost;             % Total transportation cost (objective value)

% Constraints
% --- Capacity constraints between distribution centers ---
constraint allocX + allocY <= capXY;   % Combined allocation to X and Y cannot exceed capXY
constraint allocY + allocZ <= capYZ;   % Combined allocation to Y and Z cannot exceed capYZ

% --- Minimum separation constraint between X and Z ---
constraint allocX - allocZ >= minDiffXZ;  % Allocation at X must be at least minDiffXZ more than at Z

% --- Total cost definition (integral) ---
constraint totalCost = costX * allocX + costY * allocY + costZ * allocZ;

% Objective
solve minimize totalCost;

output [
  "allocX=", show(allocX), "\n",
  "allocY=", show(allocY), "\n",
  "allocZ=", show(allocZ), "\n",
  "totalCost=", show(totalCost), "\n"
];