% Parameters
int: total_budget = 1000000;                 % Total amount to invest (dollars)
int: n_funds = 3;                            % Number of funds (X, Y, Z)
set of int: FUNDS = 1..n_funds;              % Fund index set: 1=X, 2=Y, 3=Z

array[FUNDS] of int: min_invest = [200000, 150000, 250000];     % Minimum investment per fund (dollars)
array[FUNDS] of int: return_per_million = [20000, 30000, 40000];% Return ($) per $1,000,000 invested (2%, 3%, 4%)

% Variables
array[FUNDS] of var 0..total_budget: invest; % Investment in each fund (dollars, integer)
var 0..(total_budget * max(return_per_million)): total_return;  % Total return in dollars (integer, exact)

% Constraints
% Budget allocation: invest the entire budget across all funds
constraint
  sum(f in FUNDS)(invest[f]) = total_budget;

% Minimum investment per fund
constraint
  forall(f in FUNDS) (
    invest[f] >= min_invest[f]
  );

% Upper bound per fund: cannot invest more than total budget in any single fund
constraint
  forall(f in FUNDS) (
    invest[f] <= total_budget
  );

% Exact total return in dollars using integer arithmetic (avoid floating point)
% total_return = sum_f invest[f] * (return_per_million[f] / 1_000_000)
constraint
  total_return * 1000000 =
    sum(f in FUNDS)(invest[f] * return_per_million[f]);

% Objective
solve minimize total_return;