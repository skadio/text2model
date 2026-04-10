% Parameters
% Budget caps
int: cap_XY = 5000;              % Maximum combined investment in X and Y
int: cap_ZW = 2000;              % Maximum combined investment in Z and W

% Cross-project minimum differences
int: min_diff_XZ = 1000;         % X must be at least 1000 more than Z
int: min_diff_YW = 1500;         % Y must be at least 1500 more than W

% Individual project bounds
int: max_X = 4000;               % Upper bound for investment in X
int: max_Y = 3000;               % Upper bound for investment in Y
int: min_Z = 500;                % Lower bound for investment in Z
int: min_W = 200;                % Lower bound for investment in W

% Unit costs (dollars per unit)
int: cost_X = 20;
int: cost_Y = 30;
int: cost_Z = 50;
int: cost_W = 10;

% Variables
var 0..max_X: invest_X;          % Integer investment allocated to project X
var 0..max_Y: invest_Y;          % Integer investment allocated to project Y
var min_Z..cap_ZW: invest_Z;     % Integer investment allocated to project Z
var min_W..cap_ZW: invest_W;     % Integer investment allocated to project W

var 0..(cost_X*max_X + cost_Y*max_Y + cost_Z*cap_ZW + cost_W*cap_ZW): total_cost;
                                 % Total cost in dollars (to be minimized)

% Constraints
% --- Budget cap constraints (combined investments) ---
constraint invest_X + invest_Y <= cap_XY;   % X and Y combined investment cannot exceed cap_XY
constraint invest_Z + invest_W <= cap_ZW;   % Z and W combined investment cannot exceed cap_ZW

% --- Cross-project minimum difference constraints ---
constraint invest_X - invest_Z >= min_diff_XZ;  % X must be at least min_diff_XZ more than Z
constraint invest_Y - invest_W >= min_diff_YW;  % Y must be at least min_diff_YW more than W

% --- Total cost definition constraint ---
constraint
  total_cost =
    cost_X * invest_X +
    cost_Y * invest_Y +
    cost_Z * invest_Z +
    cost_W * invest_W;

% Objective
solve minimize total_cost;