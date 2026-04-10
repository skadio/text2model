% Parameters
% Project costs (units per allocation)
int: costX = 2;
int: costY = 3;
int: costZ = 1;

% Constraint limits / requirements
int: maxXY = 1000;      % X + Y <= 1000
int: min2XplusZ = 500;  % 2*X + Z >= 500
int: diffYZ = 200;      % |Y - Z| = 200 (exact difference)
int: maxXZ = 800;       % X + Z <= 800

% Variables
var 0..max(maxXY, maxXZ): X;  % allocation to project X (non-negative integer)
var 0..maxXY: Y;              % allocation to project Y (non-negative integer)
var 0..maxXZ: Z;              % allocation to project Z (non-negative integer)

% Total cost (objective value); safe upper bound from variable domains
var 0..(costX*max(maxXY,maxXZ) + costY*maxXY + costZ*maxXZ): total_cost;

% Variables-to-objective linkage
constraint total_cost = costX*X + costY*Y + costZ*Z;

% Constraints
% --- Budget / capacity constraints ---
constraint X + Y <= maxXY;      % Combined allocation for X and Y cannot exceed maxXY
constraint X + Z <= maxXZ;      % Combined allocation for X and Z cannot exceed maxXZ

% --- Minimum development requirement ---
constraint 2 * X + Z >= min2XplusZ;  % Ensure 2*X plus Z reaches at least min2XplusZ

% --- Exact difference requirement between Y and Z ---
constraint abs(Y - Z) = diffYZ; % Enforce an exact difference of diffYZ between Y and Z

% Objective
solve minimize total_cost;

% Output (optional, for inspection)
output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " total_cost=", show(total_cost), "\n"
];