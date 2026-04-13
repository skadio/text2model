% Parameters
int: max_XY = 1000;          % Land constraint: X + Y <= 1000
int: max_YZ = 800;           % Water constraint: Y + Z <= 800
int: min_XZ = 500;           % Diversity constraint: X + Z >= 500
int: max_diff_XY = 200;      % Nutrient balance: |X - Y| <= 200

int: cost_X = 20;            % Cost per unit for crop X
int: cost_Y = 30;            % Cost per unit for crop Y
int: cost_Z = 10;            % Cost per unit for crop Z

% Variables
var 0..1000: X;              % Resources allocated to crop X
var 0..1000: Y;              % Resources allocated to crop Y
var 0..800:  Z;              % Resources allocated to crop Z

% Upper bound for total cost based on variable bounds
var 0..(cost_X*1000 + cost_Y*1000 + cost_Z*800): total_cost;

% Constraints
% Land constraint: combined allocation to crops X and Y cannot exceed max_XY
constraint X + Y <= max_XY;

% Water constraint: combined allocation to crops Y and Z cannot exceed max_YZ
constraint Y + Z <= max_YZ;

% Diversity constraint: combined allocation to crops X and Z must be at least min_XZ
constraint X + Z >= min_XZ;

% Nutrient balance constraint: difference between X and Y allocations limited by max_diff_XY
constraint abs(X - Y) <= max_diff_XY;

% Total cost definition
constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;