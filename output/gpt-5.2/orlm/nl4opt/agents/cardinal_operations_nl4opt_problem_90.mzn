% Parameters
int: profit_regular = 5000;          % Profit per regular car
int: profit_premium = 8500;          % Profit per premium car
int: demand_max_regular = 8;         % Maximum daily demand for regular cars
int: demand_max_premium = 6;         % Maximum daily demand for premium cars
int: capacity_max_total = 12;        % Maximum total cars produced per day (both types)

% Variables
var 0..demand_max_regular: x1;       % Number of regular cars produced per day
var 0..demand_max_premium: x2;       % Number of premium cars produced per day
var 0..(profit_regular*demand_max_regular + profit_premium*demand_max_premium): profit;
                                     % Total daily profit (upper bound from max demands)

% Constraints
% Demand limits are enforced by variable domains for x1 and x2.

% Capacity constraint: total number of cars (regular + premium) cannot exceed daily capacity
constraint
  x1 + x2 <= capacity_max_total;

% Profit definition: compute total daily profit from production quantities
constraint
  profit = profit_regular * x1 + profit_premium * x2;

% Objective
solve maximize profit;