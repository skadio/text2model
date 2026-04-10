% Parameters
int: budget_limit = 500;              % Maximum total investment across X, Y, Z
int: min_weighted_invest = 400;       % Minimum for 2*X + 3*Y
int: max_diff_YZ = 150;               % |Y - Z| must be <= 150
int: min_diff_XZ = 100;               % X - Z must be >= 100

int: cost_X = 50;                     % Cost per unit invested in X
int: cost_Y = 30;                     % Cost per unit invested in Y
int: cost_Z = 80;                     % Cost per unit invested in Z

% Variables
var 0..budget_limit: invest_X;         % Whole-number investment in destination X
var 0..budget_limit: invest_Y;         % Whole-number investment in destination Y
var 0..budget_limit: invest_Z;         % Whole-number investment in destination Z

var 0..(cost_X*budget_limit + cost_Y*budget_limit + cost_Z*budget_limit): total_cost;
% Total cost (to minimize)

% Constraints
% Budget limit: total investment across X, Y, Z cannot exceed the budget_limit
constraint invest_X + invest_Y + invest_Z <= budget_limit;

% Weighted promotion requirement: 2*X + 3*Y must be at least min_weighted_invest
constraint 2 * invest_X + 3 * invest_Y >= min_weighted_invest;

% Balance between Y and Z: absolute difference |Y - Z| must not exceed max_diff_YZ
constraint abs(invest_Y - invest_Z) <= max_diff_YZ;

% Ensure enough promotion for X relative to Z: X - Z must be at least min_diff_XZ
constraint invest_X - invest_Z >= min_diff_XZ;

% Define total cost from per-unit costs and investments
constraint total_cost = cost_X * invest_X + cost_Y * invest_Y + cost_Z * invest_Z;

% Objective
solve minimize total_cost;