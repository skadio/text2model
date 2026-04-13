% Parameters
int: cost_X = 10;                    % Cost per unit investment in destination X
int: cost_Y = 15;                    % Cost per unit investment in destination Y
int: cost_Z = 20;                    % Cost per unit investment in destination Z

int: max_XY = 100;                   % Upper bound on combined investment in X and Y
int: max_YZ = 150;                   % Upper bound on combined investment in Y and Z
int: min_XZ = 50;                    % Lower bound on combined investment in X and Z

% Variables
var 0..max_XY: invest_X;             % Investment units allocated to destination X (non-negative integer)
var 0..max(max_XY, max_YZ): invest_Y;% Investment units allocated to destination Y (non-negative integer)
var 0..max_YZ: invest_Z;             % Investment units allocated to destination Z (non-negative integer)

var int: total_cost;                 % Total marketing cost to minimize

% Constraints
% Compute total marketing cost from per-destination investments
constraint total_cost = cost_X * invest_X + cost_Y * invest_Y + cost_Z * invest_Z;

% Budget/limit constraint: combined investment in X and Y cannot exceed max_XY
constraint invest_X + invest_Y <= max_XY;

% Budget/limit constraint: combined investment in Y and Z cannot exceed max_YZ
constraint invest_Y + invest_Z <= max_YZ;

% Visibility/minimum presence constraint: combined investment in X and Z must be at least min_XZ
constraint invest_X + invest_Z >= min_XZ;

% Objective
solve minimize total_cost;