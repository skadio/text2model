% Parameters
int: P; % Number of products
float: Cash; % Initial cash available for investment
array[1..P] of float: Hour; % Hours required to produce one unit of product i
array[1..P] of float: Cost; % Cost to produce one unit of product i
array[1..P] of float: Price; % Selling price for one unit of product i
array[1..P] of float: InvestPercentage; % Percentage of income to reinvest for product i
float: UpgradeHours; % Hours required for upgrading the machinery
float: UpgradeCost; % Cost associated with upgrading the machinery
float: AvailableHours; % Total available machine hours

% Variables
var 0..P: upgrade; % Decision variable to determine whether to upgrade the machinery or not
array[1..P] of var 0..P: production; % Number of units of each product to produce

% Constraints

% Constraint: Total production cost and upgrade cost should not exceed available cash
constraint sum(i in 1..P) (Cost[i] * production[i]) + UpgradeCost * upgrade <= Cash;

% Constraint: Total machine hours used for production and upgrade should not exceed available hours
constraint sum(i in 1..P) (Hour[i] * production[i]) + UpgradeHours * upgrade <= AvailableHours;

% Constraint: The revenue from selling the products should be greater than or equal to the production cost
constraint forall(i in 1..P) (Price[i] * production[i] >= Cost[i] * production[i]);

% Constraint: The net income from each product should be greater than or equal to the production cost plus the investment cost
constraint forall(i in 1..P) ((Price[i] - Cost[i]) * production[i] >= InvestPercentage[i] * Price[i] * production[i]);

% Constraint: The decision to upgrade the machinery should be binary (0 or 1)
constraint upgrade in {0,1};

% Objective
solve maximize sum(i in 1..P) ((Price[i] - Cost[i]) * production[i] - InvestPercentage[i] * Price[i] * production[i]);