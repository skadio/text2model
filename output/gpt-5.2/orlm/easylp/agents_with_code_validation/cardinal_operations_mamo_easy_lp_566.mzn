% Parameters
int: maxXY = 2000;                 % Upper bound on X + Y
int: minXZ = 1000;                 % Lower bound on X + Z
int: diffYZ = 500;                 % Constraint: Y - Z = 500
int: minDiffXY = -700;             % Constraint: X - Y >= -700

int: costX = 50;                   % Cost per unit for project X
int: costY = 60;                   % Cost per unit for project Y
int: costZ = 70;                   % Cost per unit for project Z

int: maxX = 1500;                  % Maximum allocation for X
int: maxY = 1300;                  % Maximum allocation for Y
int: maxZ = 1200;                  % Maximum allocation for Z

% Variables
var 0..maxX: x;                    % Allocation to project X (integer units)
var 0..maxY: y;                    % Allocation to project Y (integer units)
var 0..maxZ: z;                    % Allocation to project Z (integer units)

% Total cost (bounded by the maximum possible spend given variable upper bounds)
var 0..(costX*maxX + costY*maxY + costZ*maxZ): total_cost;

% Constraints
% --- Allocation coupling constraints ---
constraint x + y <= maxXY;            % Combined allocation to X and Y cannot exceed maxXY
constraint x + z >= minXZ;            % Combined allocation to X and Z must be at least minXZ
constraint y - z = diffYZ;            % Difference between Y and Z must equal diffYZ
constraint x - y >= minDiffXY;        % Difference between X and Y must be at least minDiffXY

% --- Cost accounting constraint ---
constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;