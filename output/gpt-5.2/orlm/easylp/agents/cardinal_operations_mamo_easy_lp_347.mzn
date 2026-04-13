% Parameters
int: total_investment = 10000000;                % Total dollars to allocate
set of int: PROJECTS = 1..4;                     % 1=X, 2=Y, 3=Z, 4=W

array[PROJECTS] of float: return_rate =          % Expected return per dollar
  [0.05, 0.07, 0.06, 0.08];

array[PROJECTS] of int: min_invest =             % Minimum investment (dollars)
  [2000000, 0, 1500000, 0];

array[PROJECTS] of int: max_invest =             % Maximum investment (dollars)
  [total_investment, 5000000, total_investment, 3000000];

% Variables
array[PROJECTS] of var 0..total_investment: invest;  % Dollars invested in each project (whole dollars)
var float: total_return;                              % Total expected return (dollars)
var int: total_return_rounded;                        % Total expected return rounded to nearest dollar

% Constraints

% Budget constraint: allocate exactly the total investment across all projects
constraint
  sum(p in PROJECTS)(invest[p]) = total_investment;

% Investment bounds: enforce per-project minimum and maximum allocations
constraint
  forall(p in PROJECTS) (
    min_invest[p] <= invest[p] /\ invest[p] <= max_invest[p]
  );

% Define total expected return in dollars (using float return rates)
constraint
  total_return = sum(p in PROJECTS)(return_rate[p] * int2float(invest[p]));

% Round total expected return to the nearest dollar (0.5 rounds up)
constraint
  total_return_rounded = floor(total_return + 0.5);

% Objective
solve minimize total_return_rounded;