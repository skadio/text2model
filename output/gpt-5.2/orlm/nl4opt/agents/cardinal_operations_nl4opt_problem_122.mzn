% Parameters
% Total available budget (in dollars)
int: budget = 760000;

% Profit per dollar invested in each option
float: profit_per_dollar_condos = 0.50;
float: profit_per_dollar_houses = 1.0;

% Minimum fraction of total investment that must go to condos
float: min_condos_fraction = 0.20;

% Minimum dollar investment required for detached houses
int: min_houses_investment = 20000;


% Variables
% Dollars invested in condos (non-negative, cannot exceed budget)
var 0..budget: invest_condos;

% Dollars invested in detached houses (non-negative, cannot exceed budget)
var 0..budget: invest_houses;

% Total profit earned (bounded using per-dollar profit maxima)
var 0.0..(profit_per_dollar_condos * int2float(budget)
        + profit_per_dollar_houses * int2float(budget)): total_profit;


% Constraints
% Budget constraint: total investment cannot exceed available budget
constraint
  invest_condos + invest_houses <= budget;

% Minimum condos fraction: at least 20% of total invested must be in condos
constraint
  int2float(invest_condos) >=
    min_condos_fraction * int2float(invest_condos + invest_houses);

% Minimum investment in detached houses
constraint
  invest_houses >= min_houses_investment;

% Profit definition: total profit from condos and houses
constraint
  total_profit =
    profit_per_dollar_condos * int2float(invest_condos)
  + profit_per_dollar_houses * int2float(invest_houses);


% Objective
solve maximize total_profit;