% Parameters
% Daily rental costs (USD per machine)
int: cost_X = 4000;
int: cost_Y = 3000;
int: cost_Z = 6000;
int: cost_W = 5000;

% Group capacity limits
int: max_XY = 50;   % X + Y cannot exceed this
int: max_ZW = 40;   % Z + W cannot exceed this

% Minimum project requirements by combined groups
int: min_XZ = 30;   % X + Z must be at least this
int: min_YW = 20;   % Y + W must be at least this

% Individual upper bounds
int: max_X = 30;
int: max_Y = 25;
int: max_Z = 20;
int: max_W = 15;

% Variables
var 0..max_X: x;  % number of X machines rented
var 0..max_Y: y;  % number of Y machines rented
var 0..max_Z: z;  % number of Z machines rented
var 0..max_W: w;  % number of W machines rented

var int: total_cost; % total daily rental cost (USD)

% Constraints
% Compute total daily rental cost from per-machine costs
constraint
  total_cost = cost_X * x + cost_Y * y + cost_Z * z + cost_W * w;

% Budget / availability limits by machinery groups
constraint
  x + y <= max_XY;      % X and Y combined cannot exceed max_XY;
constraint
  z + w <= max_ZW;      % Z and W combined cannot exceed max_ZW

% Minimum project requirements by combined groups
constraint
  x + z >= min_XZ;      % X and Z combined must be at least min_XZ
constraint
  y + w >= min_YW;      % Y and W combined must be at least min_YW

% Objective
solve minimize total_cost;