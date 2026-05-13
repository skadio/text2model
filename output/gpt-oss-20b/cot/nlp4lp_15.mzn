% Parameters
int: P;
int: Cash;
array[1..P] of int: Hour;
array[1..P] of int: Cost;
array[1..P] of int: Price;
array[1..P] of float: InvestPercentage;
int: UpgradeHours;
int: UpgradeCost;
int: AvailableHours;

% Variables
array[1..P] of var int: x;
var bool: upgrade;

% Constraints
constraint forall(i in 1..P)(x[i] >= 0);
constraint sum(i in 1..P)(Hour[i]*x[i]) + UpgradeHours*upgrade <= AvailableHours;
constraint float(Cash) + sum(i in 1..P)(InvestPercentage[i]*float(Price[i])*x[i]) >= float(sum(i in 1..P)(Cost[i]*x[i])) + float(UpgradeCost)*upgrade;

% Objective
solve maximize sum(i in 1..P)(Price[i]*x[i] - Cost[i]*x[i]) - UpgradeCost*upgrade;