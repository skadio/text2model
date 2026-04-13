% Parameters
int: min_performance = 10;              % Minimum required performance level
int: max_capacity = 20;                 % Maximum allowed capacity usage

int: perf_coef_X = 3;                   % Coefficient of X in performance constraint
int: perf_coef_Y = 1;                   % Coefficient of Y in performance constraint

int: cap_coef_X = 2;                    % Coefficient of X in capacity constraint
int: cap_coef_Y = 4;                    % Coefficient of Y in capacity constraint

int: cost_X = 4;                        % Cost per unit of Network Upgrade (X)
int: cost_Y = 6;                        % Cost per unit of Security Enhancement (Y)

% Upper bounds derived from capacity constraint (safe integer bounds)
int: X_ub = max_capacity div cap_coef_X; % floor(20/2)=10
int: Y_ub = max_capacity div cap_coef_Y; % floor(20/4)=5

% Variables
var 0..X_ub: X;                         % Units allocated to Network Upgrade (nonnegative integer)
var 0..Y_ub: Y;                         % Units allocated to Security Enhancement (nonnegative integer)

var 0..(cost_X * X_ub + cost_Y * Y_ub): total_cost; % Total cost to minimize (bounded)

% Constraints

% Link total_cost to decision variables (linear cost definition)
constraint
  total_cost = cost_X * X + cost_Y * Y;

% Minimum performance requirement: perf_coef_X*X + perf_coef_Y*Y >= min_performance
constraint
  perf_coef_X * X + perf_coef_Y * Y >= min_performance;

% Maximum capacity usage: cap_coef_X*X + cap_coef_Y*Y <= max_capacity
constraint
  cap_coef_X * X + cap_coef_Y * Y <= max_capacity;

% Objective
solve minimize total_cost;