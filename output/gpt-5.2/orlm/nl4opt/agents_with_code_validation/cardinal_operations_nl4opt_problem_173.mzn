% Parameters
int: cost_premium = 2000;          % Manufacturing cost per premium desktop ($)
int: profit_premium = 500;         % Profit per premium desktop ($)
int: cost_regular = 1000;          % Manufacturing cost per regular desktop ($)
int: profit_regular = 300;         % Profit per regular desktop ($)
int: max_total_desktops = 200;     % Maximum desktops sold per month
int: max_budget = 300000;          % Maximum manufacturing budget per month ($)

% Variables
var 0..max_total_desktops: n_premium;  % Number of premium desktops to make/sell
var 0..max_total_desktops: n_regular;  % Number of regular desktops to make/sell

% Constraints
% Total production capacity: cannot sell more than the monthly limit
constraint
  n_premium + n_regular <= max_total_desktops;

% Manufacturing budget: total production cost cannot exceed the available budget
constraint
  cost_premium * n_premium + cost_regular * n_regular <= max_budget;

% Objective
solve maximize profit_premium * n_premium + profit_regular * n_regular;