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
array[PROD] of var 0..int: x;   % units produced/sold of each product (nonnegative)
var 0..1: doUpgrade;            % 1 if we upgrade

% Derived expressions
var int: totalRevenue = sum(i in PROD)(Price[i] * x[i]);
var int: totalProdCost = sum(i in PROD)(Cost[i] * x[i]);
var int: totalMachineHoursUsed = sum(i in PROD)(Hour[i] * x[i]);

var float: reinvestCash =
  sum(i in PROD)(InvestPercentage[i] * int2float(Price[i] * x[i]));

var int: netIncome = totalRevenue - totalProdCost - UpgradeCost * doUpgrade;

% Constraints
% Machine capacity: upgrading consumes UpgradeHours but also adds UpgradeHours,
% so net hours available remain AvailableHours.
constraint totalMachineHoursUsed + UpgradeHours * doUpgrade
         <= AvailableHours + UpgradeHours * doUpgrade;

% Cash availability: production + upgrade cost must be covered by initial cash + reinvested revenue
constraint int2float(totalProdCost + UpgradeCost * doUpgrade)
         <= int2float(Cash) + reinvestCash;

% Objective
solve maximize netIncome;