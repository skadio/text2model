% Parameters
% Costs per unit investment
int: cost_X = 7;
int: cost_Y = 3;
int: cost_Z = 5;

% Constraint constants
int: min_diversification = 10;   % 2*X + Y + Z >= 10
int: max_risk_exposure   = 15;   % X - Y + 2*Z <= 15
int: x_minus_y           = 3;    % X = Y + 3
int: max_budget          = 20;   % X + Y + Z <= 20

% Variable bounds (nonnegative, and budget gives an upper bound)
int: max_invest = max_budget;

% Variables
var 0..max_invest: X;  % units invested in option X (integer, nonnegative)
var 0..max_invest: Y;  % units invested in option Y (integer, nonnegative)
var 0..max_invest: Z;  % units invested in option Z (integer, nonnegative)

% Upper bound: worst case invest max_invest in each option
var 0..(cost_X*max_invest + cost_Y*max_invest + cost_Z*max_invest): total_cost;

% Constraints
% Diversification requirement: 2*X + Y + Z >= min_diversification
constraint 2 * X + Y + Z >= min_diversification;

% Risk exposure limit: X - Y + 2*Z <= max_risk_exposure
constraint X - Y + 2 * Z <= max_risk_exposure;

% Relationship between X and Y: X = Y + x_minus_y
constraint X = Y + x_minus_y;

% Budget limitation: X + Y + Z <= max_budget
constraint X + Y + Z <= max_budget;

% Define total_cost from unit costs
constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;