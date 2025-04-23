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
array[1..P] of var 0..Cash div min(Cost): production_units; % Number of units of each product produced
array[1..P] of var 0..Cash: net_income; % Net income from each product
var 0..AvailableHours: used_hours; % Total machine hours used
var 0..1: upgrade; % Binary variable indicating whether the machinery is upgraded or not

% Constraints

% Constraint: The cost of producing each product should not exceed the available cash
constraint forall(i in 1..P)(Cost[i] * production_units[i] <= Cash);

% Constraint: The net income from each product should be equal to the revenue minus the production cost
constraint forall(i in 1..P)(net_income[i] = Price[i] * production_units[i] - Cost[i] * production_units[i] - InvestPercentage[i] * Price[i] * production_units[i]);

% Constraint: The total machine hours used should not exceed the available hours
constraint used_hours <= AvailableHours;

% Constraint: The machine hours used for each product should be equal to the number of units produced times the hours required per unit
constraint forall(i in 1..P)(Hour[i] * production_units[i] <= used_hours);

% Objective
solve maximize sum(i in 1..P)(net_income[i]);