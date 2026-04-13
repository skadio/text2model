% Parameters
int: profit_regular = 30;          % Profit per regular handbag
int: profit_premium = 180;         % Profit per premium handbag

int: cost_regular = 200;           % Manufacturing cost per regular handbag
int: cost_premium = 447;           % Manufacturing cost per premium handbag

int: total_budget = 250000;        % Total monthly manufacturing budget
int: max_total_bags = 475;         % Maximum total handbags sold per month (both types)

% Variables
var 0..max_total_bags: regular_bags;  % Number of regular handbags to sell
var 0..max_total_bags: premium_bags;  % Number of premium handbags to sell

% Total monthly profit (bounded by selling max_total_bags all as premium)
var 0..(profit_premium * max_total_bags): total_profit;

% Constraints
% Link total_profit to decision variables (profit calculation)
constraint
  total_profit = profit_regular * regular_bags + profit_premium * premium_bags;

% Budget constraint: total manufacturing cost must not exceed total_budget
constraint
  cost_regular * regular_bags + cost_premium * premium_bags <= total_budget;

% Sales capacity constraint: total handbags sold is limited
constraint
  regular_bags + premium_bags <= max_total_bags;

% Objective
solve maximize total_profit;