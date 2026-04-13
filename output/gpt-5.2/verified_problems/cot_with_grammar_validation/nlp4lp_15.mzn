% Parameters
int: P;
set of int: PROD = 1..P;

int: Cash;
array[PROD] of int: Hour;
array[PROD] of int: Cost;
array[PROD] of int: Price;
array[PROD] of float: InvestPercentage;

int: UpgradeHours;
int: UpgradeCost;
int: AvailableHours;

% Variables
int: max_units_by_hours = if min(Hour) > 0 then AvailableHours div min(Hour) else AvailableHours endif;
array[PROD] of var 0..max_units_by_hours: x;          % units produced/sold of each product
var 0..1: upgrade;                                    % 1 if machinery is upgraded, 0 otherwise

% Constraints
constraint
  sum(i in PROD)(Hour[i] * x[i]) + UpgradeHours * upgrade <= AvailableHours;

constraint
  sum(i in PROD)(Cost[i] * x[i]) + UpgradeCost * upgrade
  <= Cash + sum(i in PROD)(InvestPercentage[i] * int2float(Price[i] * x[i]));

% Objective
var float: NetIncome =
  sum(i in PROD)(int2float((Price[i] - Cost[i]) * x[i])) - int2float(UpgradeCost) * int2float(upgrade);

solve maximize NetIncome;