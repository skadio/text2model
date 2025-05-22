int: P;
int: Cash;
array[1..P] of int: Hour;
array[1..P] of int: Cost;
array[1..P] of int: Price;
array[1..P] of float: InvestPercentage;
int: UpgradeHours;
int: UpgradeCost;
int: AvailableHours;

set of int: PRODUCTS = 1..P;

array[PRODUCTS] of int: ub =
  [ (AvailableHours + UpgradeHours) div Hour[i] | i in PRODUCTS ];

int: max_ub = max(i in PRODUCTS)(ub[i]);

array[PRODUCTS] of var 0..max_ub: x;
var 0..1: upgrade;

constraint
  sum(i in PRODUCTS)(Hour[i] * x[i]) <= AvailableHours + upgrade * UpgradeHours;

constraint
  let {
    var float: total_cost =
      sum(i in PRODUCTS)(float(Cost[i]) * float(x[i])) +
      float(UpgradeCost) * float(upgrade);
    var float: available_cash =
      float(Cash) +
      sum(i in PRODUCTS)(InvestPercentage[i] * float(Price[i]) * float(x[i]));
  } in
    total_cost <= available_cash;

solve maximize
  sum(i in PRODUCTS)(Price[i] * x[i]) -
  sum(i in PRODUCTS)(Cost[i] * x[i]) -
  UpgradeCost * upgrade;