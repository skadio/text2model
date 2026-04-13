% Parameters
int: budget_max = 500;                 % Maximum total investment allowed (X + Y + Z)
int: min_weighted_invest = 400;        % Minimum required for 2*X + 3*Y
int: max_diff_YZ = 150;                % Maximum allowed difference Y - Z
int: min_diff_XZ = 100;                % Minimum required difference X - Z

int: cost_X = 50;                      % Cost per unit invested in destination X
int: cost_Y = 30;                      % Cost per unit invested in destination Y
int: cost_Z = 80;                      % Cost per unit invested in destination Z

% Variables
var 0..budget_max: invest_X;           % Whole-number investment in destination X
var 0..budget_max: invest_Y;           % Whole-number investment in destination Y
var 0..budget_max: invest_Z;           % Whole-number investment in destination Z

var 0..(cost_X*budget_max + cost_Y*budget_max + cost_Z*budget_max): total_cost;
                                       % Total cost to minimize (safe upper bound)

% Constraints
% Budget limit: total investment across X, Y, Z cannot exceed budget_max
constraint invest_X + invest_Y + invest_Z <= budget_max;

% Weighted minimum promotion requirement: 2*X + 3*Y must be at least min_weighted_invest
constraint 2 * invest_X + 3 * invest_Y >= min_weighted_invest;

% Balance between Y and Z: difference (Y - Z) must not exceed max_diff_YZ
constraint invest_Y - invest_Z <= max_diff_YZ;

% Ensure enough promotion for X vs Z: difference (X - Z) must be at least min_diff_XZ
constraint invest_X - invest_Z >= min_diff_XZ;

% Total cost definition based on per-unit costs
constraint total_cost = cost_X * invest_X + cost_Y * invest_Y + cost_Z * invest_Z;

% Objective
solve minimize total_cost;