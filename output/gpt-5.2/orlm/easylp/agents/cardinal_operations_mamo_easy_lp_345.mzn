% Parameters
int: budget = 10000;                          % Total budget to allocate (in whole dollars)
int: n_invest = 4;                            % Number of investment options
set of int: INVEST = 1..n_invest;             % Index set for investments

array[INVEST] of float: risk = [0.06, 0.05, 0.07, 0.08];  % Risk coefficients for x1..x4
array[INVEST] of float: ret  = [0.04, 0.02, 0.00, 0.00];  % Return rates (only x1, x2 used)

int: return_diff_min = 200;                   % Minimum required (0.04*x1 - 0.02*x2) in dollars
int: exposure_diff_max = 500;                 % Maximum allowed |x3 - 2*x4| in dollars

array[INVEST] of int: lb = [0, 0, 0, 0];      % Lower bounds for x1..x4
array[INVEST] of int: ub = [10000, 10000, 10000, 10000]; % Upper bounds for x1..x4

% Variables
array[INVEST] of var int: x;                  % Allocation to each investment option (whole dollars)
var float: total_risk;                        % Total risk score (objective expression)

% Constraints
% --- Allocation bounds (whole-dollar investments within given limits) ---
constraint
  forall(i in INVEST) (
    lb[i] <= x[i] /\ x[i] <= ub[i]
  );

% --- Budget balance (fully allocate the available budget) ---
constraint
  sum(i in INVEST)(x[i]) = budget;

% --- Minimum return spread requirement: 0.04*x1 - 0.02*x2 >= 200 ---
constraint
  ret[1] * int2float(x[1]) - ret[2] * int2float(x[2]) >= int2float(return_diff_min);

% --- Exposure control: |x3 - 2*x4| <= 500 ---
constraint
  abs(x[3] - 2 * x[4]) <= exposure_diff_max;

% --- Total risk aggregation (define objective expression) ---
constraint
  total_risk = sum(i in INVEST)(risk[i] * int2float(x[i]));

% Objective
solve minimize total_risk;

output [
  "x = ", show(x), "\n",
  "total_risk = ", show(total_risk), "\n"
];