int: P;
set of int: PRODUCTS = 1..P;

int: Cash;
array[PRODUCTS] of int: Hour;
array[PRODUCTS] of int: Cost;
array[PRODUCTS] of int: Price;
array[PRODUCTS] of float: InvestPercentage;

int: UpgradeHours;
int: UpgradeCost;
int: AvailableHours;

array[PRODUCTS] of var 0..max_int: x;
var 0..1: y;

var int: totalMachineHoursUsed = sum(i in PRODUCTS)(Hour[i] * x[i]);
var float: totalProdCost = sum(i in PRODUCTS)(int2float(Cost[i] * x[i]));
var float: totalRevenue = sum(i in PRODUCTS)(int2float(Price[i] * x[i]));
var float: reinvestCash = sum(i in PRODUCTS)(InvestPercentage[i] * int2float(Price[i] * x[i]));
var float: netIncome = totalRevenue - totalProdCost - int2float(UpgradeCost) * int2float(y);

constraint totalMachineHoursUsed <= AvailableHours;

constraint totalProdCost + int2float(UpgradeCost) * int2float(y) <= int2float(Cash) + reinvestCash;

solve maximize netIncome;