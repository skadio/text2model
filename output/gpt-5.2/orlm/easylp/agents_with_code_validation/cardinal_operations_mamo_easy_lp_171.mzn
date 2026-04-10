% Parameters
% Budgets / limits (all values embedded as per instructions)
int: max_XY = 1000;          % Upper bound on investment in X + Y
int: max_YZ = 800;           % Upper bound on investment in Y + Z
int: min_XZ = 500;           % Lower bound on investment in X + Z

% ROI per dollar (included for completeness; not used in objective/constraints here)
int: roi_X = 2;
int: roi_Y = 3;
int: roi_Z = 5;

% Variable bounds derived from constraints
int: X_ub = max_XY;                  % from X + Y <= 1000
int: Y_ub = min(max_XY, max_YZ);     % from Y <= 1000 and Y <= 800
int: Z_ub = max_YZ;                  % from Y + Z <= 800

% Variables
var 0..X_ub: invest_X;       % Whole-dollar investment in channel X
var 0..Y_ub: invest_Y;       % Whole-dollar investment in channel Y
var 0..Z_ub: invest_Z;       % Whole-dollar investment in channel Z

var 0..(X_ub + Y_ub + Z_ub): total_cost;  % Total spend (to be minimized)

% Constraints
% --- Budget / limit constraints between channel pairs ---
constraint invest_X + invest_Y <= max_XY;     % X + Y must not exceed 1000
constraint invest_Y + invest_Z <= max_YZ;     % Y + Z must not exceed 800
constraint invest_X + invest_Z >= min_XZ;     % X + Z must be at least 500

% --- Total cost definition (sum of all investments) ---
constraint total_cost = invest_X + invest_Y + invest_Z;

% Objective
solve minimize total_cost;