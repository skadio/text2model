int: P;
set of int: PRODUCTS = 1..P;

float: Cash;

array[PRODUCTS] of float: Hour;
array[PRODUCTS] of float: Cost;
array[PRODUCTS] of float: Price;
array[PRODUCTS] of float: InvestPercentage;

float: UpgradeHours;
float: UpgradeCost;
float: AvailableHours;

% Decision variables
array[PRODUCTS] of var int: x;          % units produced of each product
var bool: doUpgrade;                    % whether to upgrade machinery

% Nonnegativity
constraint forall(i in PRODUCTS) (x[i] >= 0);

% Machine capacity: production hours plus upgrade hours (if performed) limited by available hours
constraint sum(i in PRODUCTS)(Hour[i] * x[i]) + (if doUpgrade then UpgradeHours else 0.0 endif)
         <= AvailableHours;

% Cash availability:
% production costs + upgrade cost must be financed by initial cash + reinvestable share of revenue
constraint sum(i in PRODUCTS)(Cost[i] * x[i]) + (if doUpgrade then UpgradeCost else 0.0 endif)
         <= Cash + sum(i in PRODUCTS)(InvestPercentage[i] * Price[i] * x[i]);

% Objective: maximize total net income = revenue - production cost - upgrade cost
var float: total_net_income =
    sum(i in PRODUCTS)((Price[i] - Cost[i]) * x[i]) - (if doUpgrade then UpgradeCost else 0.0 endif);

solve maximize total_net_income;

output [
  "x = ", show(x), "\n",
  "doUpgrade = ", show(doUpgrade), "\n",
  "total_net_income = ", show(total_net_income), "\n"
];