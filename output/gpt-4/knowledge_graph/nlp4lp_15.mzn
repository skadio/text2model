include "globals.mzn";

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
array[1..P] of var 0..Cash div min(Cost): Production; % Number of units to produce for each product
var 0..Cash: Investment; % Amount of money to invest in upgrading the machinery
var 0..AvailableHours: Upgrade; % Number of hours to spend on upgrading the machinery

% Constraints
constraint forall(i in 1..P)(Hour[i]*Production[i] <= AvailableHours - Upgrade);
constraint forall(i in 1..P)(Cost[i]*Production[i] + Investment <= Cash);
constraint Upgrade*UpgradeHours <= AvailableHours;
constraint Investment <= UpgradeCost*Upgrade;

% Objective
var int: NetIncome = sum(i in 1..P)(Price[i]*Production[i]) - sum(i in 1..P)(Cost[i]*Production[i]) - Investment;
solve maximize NetIncome;

% Output
output ["Net income: ", show(NetIncome), "\n"] ++
["Production: "] ++ [show(Production[i]) | i in 1..P] ++ ["\n"] ++
["Investment: ", show(Investment), "\n"] ++
["Upgrade: ", show(Upgrade), "\n"];