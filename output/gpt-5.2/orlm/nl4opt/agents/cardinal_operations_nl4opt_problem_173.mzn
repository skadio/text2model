% Parameters
int: cost_premium = 2000;          % Manufacturing cost per premium desktop ($)
int: profit_premium = 500;         % Profit per premium desktop ($)
int: cost_regular = 1000;          % Manufacturing cost per regular desktop ($)
int: profit_regular = 300;         % Profit per regular desktop ($)

int: max_total_desktops = 200;     % Maximum desktops sold per month
int: max_total_cost = 300000;      % Maximum total manufacturing budget ($)

% Variables
var 0..max_total_desktops: n_premium;  % Number of premium desktops to make/sell
var 0..max_total_desktops: n_regular;  % Number of regular desktops to make/sell

% Total profit variable (bounded for solver efficiency)
var 0..(profit_premium * max_total_desktops + profit_regular * max_total_desktops): total_profit;

% Constraints
% Total sales limit: at most max_total_desktops desktops sold per month
constraint n_premium + n_regular <= max_total_desktops;

% Manufacturing budget limit: total cost cannot exceed max_total_cost
constraint cost_premium * n_premium + cost_regular * n_regular <= max_total_cost;

% Define total profit based on quantities produced/sold
constraint total_profit = profit_premium * n_premium + profit_regular * n_regular;

% Objective
solve maximize total_profit;