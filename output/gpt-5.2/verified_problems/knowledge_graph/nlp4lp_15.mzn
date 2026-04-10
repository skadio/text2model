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

array[PRODUCTS] of var float: x;          % units produced/sold (unlimited demand => bounded by resources)
var float: upgrade;                       % hours spent on repairs/upgrades (0..UpgradeHours)

constraint forall(i in PRODUCTS)(x[i] >= 0.0);
constraint upgrade >= 0.0 /\ upgrade <= UpgradeHours;

% Machine capacity: production uses machine hours; upgrades consume hours but add the same amount of capacity
constraint
  sum(i in PRODUCTS)(Hour[i] * x[i]) <= AvailableHours + upgrade;

% Cash availability: production costs and upgrade cost must be financed by initial cash plus reinvested sales revenues
constraint
  sum(i in PRODUCTS)(Cost[i] * x[i]) + UpgradeCost <=
  Cash + sum(i in PRODUCTS)(InvestPercentage[i] * Price[i] * x[i]);

% Net income objective: revenue - production cost - upgrade cost
var float: TotalNetIncome =
  sum(i in PRODUCTS)((Price[i] - Cost[i]) * x[i]) - UpgradeCost;

solve maximize TotalNetIncome;

output [
  "TotalNetIncome=", show(TotalNetIncome), "\n",
  "upgrade=", show(upgrade), "\n",
  "x=", show(x), "\n"
];