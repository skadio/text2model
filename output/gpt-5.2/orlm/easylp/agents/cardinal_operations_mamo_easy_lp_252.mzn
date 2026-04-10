% Parameters
% All data is embedded directly as per instructions (no .dzn expected)

int: budget_XY_max = 1000;          % X + Y <= 1000
int: min_YZ = 500;                  % Y + Z >= 500
int: max_diff_XZ = 200;             % |X - Z| <= 200

int: cost_X = 4;                    % cost per unit allocated to X
int: cost_Y = 3;                    % cost per unit allocated to Y
int: cost_Z = 2;                    % cost per unit allocated to Z

% Variable bounds (safe, explicit upper bounds derived from constraints)
int: max_X = budget_XY_max;         % since X <= X+Y <= 1000
int: max_Y = budget_XY_max;         % since Y <= X+Y <= 1000
int: max_Z = max_X + max_diff_XZ;   % since Z <= X + 200 and X <= 1000 => Z <= 1200


% Variables
var 0..max_X: X;   % resource allocation to procurement
var 0..max_Y: Y;   % resource allocation to manufacturing
var 0..max_Z: Z;   % resource allocation to distribution

% Objective value (explicit upper bound for robustness)
var 0..(cost_X*max_X + cost_Y*max_Y + cost_Z*max_Z): total_cost;


% Constraints

% Budget limit for procurement and manufacturing
constraint X + Y <= budget_XY_max;

% Minimum combined allocation for manufacturing and distribution
constraint Y + Z >= min_YZ;

% Balance constraint between procurement and distribution (absolute difference)
constraint abs(X - Z) <= max_diff_XZ;

% Define total cost from unit costs and allocations
constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;


% Objective
solve minimize total_cost;