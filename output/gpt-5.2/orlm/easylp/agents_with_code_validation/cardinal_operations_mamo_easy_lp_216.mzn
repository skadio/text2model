% Parameters
% Resource allocation costs (units per resource)
int: costX = 5;
int: costY = 3;
int: costZ = 2;

% Capacity / requirement bounds
int: maxXY = 1000;   % X + Y <= 1000
int: maxYZ = 800;    % Y + Z <= 800
int: minXZ = 500;    % X + Z >= 500

% Variables
% Whole-number allocations to each department (non-negative)
var 0..maxXY: x;   % allocation to department X
var 0..maxXY: y;   % allocation to department Y
var 0..maxYZ: z;   % allocation to department Z

% Total cost (upper bound derived from variable bounds)
var 0..(costX*maxXY + costY*maxXY + costZ*maxYZ): total_cost;

% Constraints
%--- Capacity constraints between departments ---
constraint x + y <= maxXY;
constraint y + z <= maxYZ;

%--- Minimum balance requirement ---
constraint x + z >= minXZ;

%--- Total cost definition ---
constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;