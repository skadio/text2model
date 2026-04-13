% Parameters
% Constraint limits
int: max_XY = 1000;     % X + Y cannot exceed this (land constraint)
int: max_YZ = 800;      % Y + Z cannot exceed this (water constraint)
int: min_XZ = 500;      % X + Z must be at least this (diversity constraint)
int: max_diff_XY = 200; % |X - Y| cannot exceed this (nutrient balance)

% Unit costs (dollars per unit resource)
int: costX = 20;
int: costY = 30;
int: costZ = 10;

% Derived safe upper bounds for decision variables (non-negative resources)
int: UB_X = max_XY;                 % from X + Y <= max_XY and Y >= 0
int: UB_Y = min(max_XY, max_YZ);    % since Y <= max_XY and Y <= max_YZ (with Z,X >= 0)
int: UB_Z = max_YZ;                 % from Y + Z <= max_YZ and Y >= 0


% Variables
var 0..UB_X: X; % resources allocated to crop X (integer, non-negative)
var 0..UB_Y: Y; % resources allocated to crop Y (integer, non-negative)
var 0..UB_Z: Z; % resources allocated to crop Z (integer, non-negative)

% Total cost (bounded safely using variable upper bounds)
var 0..(costX*UB_X + costY*UB_Y + costZ*UB_Z): total_cost;


% Constraints
% --- Land constraint: total resources for crops X and Y ---
constraint X + Y <= max_XY;

% --- Water constraint: total resources for crops Y and Z ---
constraint Y + Z <= max_YZ;

% --- Diversity constraint: combined resources for crops X and Z ---
constraint X + Z >= min_XZ;

% --- Nutrient balance constraint: limit absolute difference between X and Y ---
constraint abs(X - Y) <= max_diff_XY;

% --- Total cost definition: link total_cost to decision variables ---
constraint total_cost = costX * X + costY * Y + costZ * Z;


% Objective
solve minimize total_cost;