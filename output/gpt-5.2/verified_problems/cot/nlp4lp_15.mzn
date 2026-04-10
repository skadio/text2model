% Parameters
int: P;
set of int: Products = 1..P;

int: Cash;
array[Products] of int: Hour;
array[Products] of int: Cost;
array[Products] of int: Price;
array[Products] of float: InvestPercentage;

int: UpgradeHours;
int: UpgradeCost;
int: AvailableHours;

% Variables
array[Products] of var int: x;          % units produced of each product
var int: upgrade;                       % 1 if upgrade performed, 0 otherwise

var int: TotalProdCost;
var int: TotalRevenue;
var float: TotalReinvest;
var int: NetIncome;

% Constraints
constraint upgrade in 0..1;

constraint forall(i in Products) (x[i] >= 0);

% Machine hours: production uses hours; upgrade consumes hours but adds hours
constraint
  sum(i in Products)(Hour[i] * x[i]) + UpgradeHours * upgrade <= AvailableHours + UpgradeHours * upgrade;

% Cash availability: production costs and upgrade cost must be financed by initial cash + reinvested revenue
constraint
  TotalProdCost = sum(i in Products)(Cost[i] * x[i]);

constraint
  TotalRevenue = sum(i in Products)(Price[i] * x[i]);

constraint
  TotalReinvest = sum(i in Products)(InvestPercentage[i] * (Price[i] * x[i]));

constraint
  TotalProdCost + UpgradeCost * upgrade <= Cash + TotalReinvest;

% Net income = revenue - production cost - upgrade cost
constraint
  NetIncome = TotalRevenue - TotalProdCost - UpgradeCost * upgrade;

% Objective
solve maximize NetIncome;