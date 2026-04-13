% Parameters
int: profit_regular = 5000;        % Profit per regular car
int: profit_premium = 8500;        % Profit per premium car
int: max_demand_regular = 8;       % Maximum daily demand for regular cars
int: max_demand_premium = 6;       % Maximum daily demand for premium cars
int: max_total_cars = 12;          % Maximum total cars produced per day (either type)

% Variables
var 0..max_demand_regular: x1;     % Number of regular cars produced per day
var 0..max_demand_premium: x2;     % Number of premium cars produced per day
var 0..(profit_regular*max_demand_regular + profit_premium*max_demand_premium): total_profit;

% Constraints
% Link total_profit to the number of cars produced and their respective profits
constraint
  total_profit = profit_regular * x1 + profit_premium * x2;

% Respect overall production capacity (maximum total cars per day)
constraint
  x1 + x2 <= max_total_cars;

% Demand upper bounds are already enforced by variable domains:
%   x1 in 0..max_demand_regular
%   x2 in 0..max_demand_premium

% Objective
solve maximize total_profit;