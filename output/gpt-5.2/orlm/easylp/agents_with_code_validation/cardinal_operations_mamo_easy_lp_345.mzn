% Parameters
int: BUDGET = 10000;                            % Total budget to allocate (in whole dollars)
int: nInvest = 4;                               % Number of investment options
set of int: INVEST = 1..nInvest;                % Index set for investments

array[INVEST] of float: risk = [0.06, 0.05, 0.07, 0.08];   % Risk coefficients for x1..x4
array[INVEST] of float: ret  = [0.04, 0.02, 0.0, 0.0];     % Return rates (given for x1 and x2; others unused)

int: minReturnDiff = 200;                       % Minimum required difference: 0.04*x1 - 0.02*x2 >= 200
int: maxDiff34 = 500;                           % Maximum allowed: x3 - 2*x4 <= 500

array[INVEST] of int: lb = [0, 0, 0, 0];        % Lower bounds for allocations (whole dollars)
array[INVEST] of int: ub = [BUDGET, BUDGET, BUDGET, BUDGET]; % Upper bounds for allocations

% Variables
array[INVEST] of var int: x;                    % Allocation to each investment (in whole dollars)
var float: total_risk;                          % Total risk score (objective value)

% Constraints

% Allocation bounds (redundant if domains already restricted, but kept for clarity)
constraint
  forall(i in INVEST) (
    lb[i] <= x[i] /\ x[i] <= ub[i]
  );

% Budget must be fully allocated across all investments
constraint
  sum(i in INVEST)(x[i]) = BUDGET;

% Minimum return difference constraint:
% 0.04*x1 - 0.02*x2 >= 200  (scaled by 100 to keep it integer)
constraint
  4 * x[1] - 2 * x[2] >= 100 * minReturnDiff;

% Diversification/exposure constraint:
% x3 - 2*x4 <= 500
constraint
  x[3] - 2 * x[4] <= maxDiff34;

% Define total risk as the weighted sum of allocations
constraint
  total_risk = sum(i in INVEST)(risk[i] * int2float(x[i]));

% Objective
solve minimize total_risk;