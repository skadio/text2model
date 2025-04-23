include "globals.mzn";

% Number of products
int: P;

% Initial cash available for investment
int: Cash;

% Hours required to produce one unit of product i
array[1..P] of int: Hour;

% Cost to produce one unit of product i
array[1..P] of int: Cost;

% Selling price for one unit of product i
array[1..P] of int: Price;

% Percentage of income to reinvest for product i
array[1..P] of float: InvestPercentage;

% Hours required for upgrading the machinery
int: UpgradeHours;

% Cost associated with upgrading the machinery
int: UpgradeCost;

% Total available machine hours
int: AvailableHours;

% Decision variables
array[1..P] of var 0..Cash div min(Cost): Units;
var 0..1: Upgrade;

% Objective function
var int: NetIncome = sum(i in 1..P) ((Price[i] - Cost[i]) * Units[i]) - Upgrade * UpgradeCost;

% Constraints
constraint sum(i in 1..P) (Hour[i] * Units[i]) <= AvailableHours + Upgrade * UpgradeHours;
constraint sum(i in 1..P) (Cost[i] * Units[i]) <= Cash - Upgrade * UpgradeCost;
constraint forall(i in 1..P) (Units[i] * Price[i] * InvestPercentage[i] <= Cash);

% Solve
solve maximize NetIncome;

% Output
output [ "Net Income: " ++ show(NetIncome) ++ "\n" ] ++
[ if fix(Units[i]) > 0 then "Product " ++ show(i) ++ ": " ++ show(Units[i]) ++ " units\n" else "" endif | i in 1..P ] ++
[ if fix(Upgrade) = 1 then "Upgrade machinery\n" else "" endif ];