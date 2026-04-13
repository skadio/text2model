% Parameters
% Project costs (units per allocation)
int: costX = 2;
int: costY = 3;
int: costZ = 1;

% Constraint right-hand sides / constants
int: maxXY  = 1000;  % X + Y <= 1000
int: min2XZ = 500;   % 2*X + Z >= 500
int: diffYZ = 200;   % abs(Y - Z) = 200
int: maxXZ  = 800;   % X + Z <= 800


% Variables
% Resource allocations (whole numbers, non-negative)
var 0..maxXY: X;   % allocation to project X
var 0..maxXY: Y;   % allocation to project Y
var 0..maxXZ: Z;   % allocation to project Z


% Constraints
% Budget cap on combined allocations for projects X and Y
constraint X + Y <= maxXY;

% Minimum balanced development requirement: 2*X + Z must meet or exceed threshold
constraint 2 * X + Z >= min2XZ;

% Exact difference requirement between Y and Z allocations
constraint abs(Y - Z) = diffYZ;

% Additional cap on combined allocations for projects X and Z
constraint X + Z <= maxXZ;


% Objective
solve minimize costX * X + costY * Y + costZ * Z;