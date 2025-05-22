% Parameters
int: P; % Number of products
int: Cash; % Initial cash available for investment
array[1..P] of int: Hour; % Hours required to produce one unit of product i
array[1..P] of int: Cost; % Cost to produce one unit of product i
array[1..P] of int: Price; % Selling price for one unit of product i
array[1..P] of float: InvestPercentage; % Percentage of income to reinvest for product i
int: UpgradeHours; % Hours required for upgrading the machinery
int: UpgradeCost; % Cost associated with upgrading the machinery
int: AvailableHours; % Total available machine hours

% Variables
array[1..P] of var 0..Cash div min(Cost): Units; % Units of each product to produce
var 0..1: Upgrade; % Whether to upgrade the machinery or not

% Constraints
constraint forall(i in 1..P)(Units[i]*Hour[i] <= AvailableHours + Upgrade*UpgradeHours);
constraint forall(i in 1..P)(Units[i]*Cost[i] <= Cash - Upgrade*UpgradeCost);
constraint forall(i in 1..P)(Units[i]*Price[i]*InvestPercentage[i] <= Cash);

% Objective
var int: TotalIncome = sum(i in 1..P)(Units[i]*(Price[i] - Cost[i]) - Upgrade*UpgradeCost);
solve maximize TotalIncome;