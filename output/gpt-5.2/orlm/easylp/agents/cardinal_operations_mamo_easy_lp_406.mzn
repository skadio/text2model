% Parameters
% Cost per unit allocated to each vessel
int: cost_X = 10;
int: cost_Y = 15;
int: cost_Z = 20;
int: cost_W = 25;

% Capacity/limit constraints
int: cap_XY = 500;   % X + Y cannot exceed this
int: cap_ZW = 700;   % Z + W cannot exceed this

% Minimum load/balance constraints
int: min_XZ = 200;   % X + Z must be at least this
int: min_YW = 300;   % Y + W must be at least this


% Variables
% Integer cargo allocations to each vessel (non-negative)
var 0..cap_XY: x;  % allocation to vessel X
var 0..cap_XY: y;  % allocation to vessel Y
var 0..cap_ZW: z;  % allocation to vessel Z
var 0..cap_ZW: w;  % allocation to vessel W


% Constraints
% Capacity constraints (upper bounds on combined allocations)
constraint x + y <= cap_XY;  % Vessels X and Y combined capacity limit
constraint z + w <= cap_ZW;  % Vessels Z and W combined capacity limit

% Minimum load / balancing constraints (lower bounds on combined allocations)
constraint x + z >= min_XZ;  % Ensure enough load on vessels X and Z combined
constraint y + w >= min_YW;  % Ensure enough load on vessels Y and W combined


% Objective
solve minimize cost_X * x + cost_Y * y + cost_Z * z + cost_W * w;