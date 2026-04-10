% Parameters
% Cost per unit allocated to each project
int: costX = 50;
int: costY = 60;
int: costZ = 70;

% Allocation upper bounds (maximum units per project)
int: maxX = 1500;
int: maxY = 1300;
int: maxZ = 1200;

% Constraint constants
int: maxXY = 2000;     % X + Y <= 2000
int: minXZ = 1000;     % X + Z >= 1000
int: diffYZ = 500;     % Y - Z = 500
int: minDiffXY = -700; % X - Y >= -700

% Variables
% Integer allocations (units) to each project
var 0..maxX: x;  % allocation to project X
var 0..maxY: y;  % allocation to project Y
var 0..maxZ: z;  % allocation to project Z

% Total cost (bounded explicitly)
var 0..(costX*maxX + costY*maxY + costZ*maxZ): total_cost;

% Constraints

% --- Allocation feasibility constraints ---

% Combined allocation for projects X and Y cannot exceed the budget cap
constraint x + y <= maxXY;

% Combined allocation for projects X and Z must meet the minimum requirement
constraint x + z >= minXZ;

% Interdependency constraint: difference between Y and Z must be exactly diffYZ
constraint y - z = diffYZ;

% Difference constraint between X and Y must not be less than minDiffXY
constraint x - y >= minDiffXY;

% --- Cost definition constraint ---

% Define total cost as the linear combination of allocations and per-unit costs
constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;