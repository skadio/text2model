% Parameters
% Resource requirements per unit of effort for each project
int: resX = 2;
int: resY = 3;
int: resZ = 1;

% Constraint parameters
int: min_XY = 10;        % Minimum combined effort of X and Y
int: max_2X_Z = 15;      % Maximum allowed value of (2*X + Z)
int: min_Y_minus_Z = 5;  % Minimum required value of (Y - Z)

% Derived safe upper bounds from constraints (to keep the search finite)
int: maxX = max_2X_Z div 2;            % since 2*X + Z <= 15 and Z >= 0
int: maxZ = max_2X_Z;                  % since 2*X + Z <= 15 and X >= 0
int: maxY = maxZ + min_Y_minus_Z;      % since Y - Z >= 5 and Z <= maxZ


% Variables
var 0..maxX: x;  % Effort in Project X (forest conservation)
var 0..maxY: y;  % Effort in Project Y (marine life protection)
var 0..maxZ: z;  % Effort in Project Z (climate mitigation)

% Total resources used (bounded by the worst-case within variable domains)
var 0..(resX * maxX + resY * maxY + resZ * maxZ): total_resources;


% Constraints
% Strategic objective: minimum combined effort for Projects X and Y
constraint x + y >= min_XY;

% Resource feasibility: limit on (2*X + Z)
constraint 2 * x + z <= max_2X_Z;

% Priority constraint: marine life protection effort exceeds climate mitigation by at least a margin
constraint y - z >= min_Y_minus_Z;

% Define total resource consumption from per-unit resource requirements
constraint total_resources = resX * x + resY * y + resZ * z;


% Objective
solve minimize total_resources;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_resources=", show(total_resources), "\n"
];