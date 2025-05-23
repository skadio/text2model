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
array[1..P] of var 0..Cash div min(Cost): Product; % Number of each product to produce
var 0..1: Upgrade; % Whether to upgrade the machinery or not

% Constraints
constraint sum(i in 1..P)(Product[i]*Hour[i]) <= AvailableHours + Upgrade*UpgradeHours;
constraint sum(i in 1..P)(Product[i]*Cost[i]) <= Cash - Upgrade*UpgradeCost;
constraint forall(i in 1..P)(Product[i]*Cost[i] + Upgrade*UpgradeCost <= Cash*InvestPercentage[i]);

% Objective
var int: NetIncome = sum(i in 1..P)(Product[i]*(Price[i] - Cost[i])) - Upgrade*UpgradeCost;
solve maximize NetIncome;