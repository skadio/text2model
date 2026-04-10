% Parameters
% Resource usage per unit effort for each project (given in problem statement)
int: resX = 2;
int: resY = 3;
int: resZ = 1;

% Constraint constants (given in problem statement)
int: minXY = 10;      % X + Y >= 10
int: max2XZ = 15;     % 2*X + Z <= 15
int: minYminusZ = 5;  % Y - Z >= 5

% Variables
var 0..max2XZ: x;  % effort in Project X (non-negative integer)
var 0..max2XZ: y;  % effort in Project Y (non-negative integer)
var 0..max2XZ: z;  % effort in Project Z (non-negative integer)

% Upper bound uses worst case: all efforts at max2XZ
var 0..(resX*max2XZ + resY*max2XZ + resZ*max2XZ): total_resource;

% Constraints
% Link total_resource to the weighted sum of project efforts
constraint
  total_resource = resX * x + resY * y + resZ * z;

% Strategic objective: combined efforts of Projects X and Y must be at least minXY
constraint
  x + y >= minXY;

% Resource/feasibility limit: twice effort in X plus effort in Z must not exceed max2XZ
constraint
  2 * x + z <= max2XZ;

% Priority condition: effort in Y must exceed effort in Z by at least minYminusZ
constraint
  y - z >= minYminusZ;

% Objective
solve minimize total_resource;