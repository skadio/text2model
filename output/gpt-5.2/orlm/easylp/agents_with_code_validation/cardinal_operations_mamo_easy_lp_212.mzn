% Parameters
% Unit costs per resource allocated to each department
int: costX = 2;
int: costY = 3;
int: costZ = 1;

% Constraint thresholds
int: minXY = 50;      % X + Y must be at least this value
int: maxXZ = 100;     % X + Z cannot exceed this value
int: minDiffYZ = 10;  % Y - Z must be at least this value

% Simple safe upper bound for individual allocations (from X+Z <= 100 and non-negativity)
int: ubAlloc = maxXZ;

% Variables
var 0..ubAlloc: x;  % resources allocated to department X
var 0..ubAlloc: y;  % resources allocated to department Y
var 0..ubAlloc: z;  % resources allocated to department Z

var int: totalCost; % total cost to minimize

% Constraints

% Service level requirement: combined allocation to X and Y must be at least minXY
constraint x + y >= minXY;

% Budget restriction: combined allocation to X and Z cannot exceed maxXZ
constraint x + z <= maxXZ;

% Prioritization constraint: Y must exceed Z by at least minDiffYZ
constraint y - z >= minDiffYZ;

% Total cost definition
constraint totalCost = costX * x + costY * y + costZ * z;

% Objective
solve minimize totalCost;