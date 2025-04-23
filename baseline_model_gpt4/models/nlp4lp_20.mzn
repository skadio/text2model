include "globals.mzn";

% Parameters
int: I; % Number of types of oil
int: M; % Number of months
array[1..I, 1..M] of int: BuyPrice; % Buying price of oil i in month m
int: SellPrice; % Selling price of final product
array[1..I] of bool: IsVegetable; % Indicator whether good i is a vegetable oil or not
int: MaxVegRefiningPerMonth; % Maximum refining capacity for refinding vegetable oil per month
int: MaxNonVegRefiningPerMonth; % Maximum refining capacity for non-vegetable oil per month
int: StorageSize; % Storage capacity for raw oil
int: StorageCost; % Storage cost per unit per month
int: MaxHardness; % Maximum hardness of final product
int: MinHardness; % Minimum hardness of final product
array[1..I] of float: Hardness; % Hardness of good i
int: InitialAmount; % Initial amount of oil of each type that's available for processing
int: MinUsage; % If an oil is used in a month, at least MinUsage tons must be used.
array[1..I, 1..I] of bool: Dependencies; % Dependencies of goods i

% Variables
array[1..I, 1..M] of var 0..StorageSize: Buy; % Amount of oil i bought in month m
array[1..I, 1..M] of var 0..StorageSize: Store; % Amount of oil i stored in month m
array[1..I, 1..M] of var 0..MaxVegRefiningPerMonth + MaxNonVegRefiningPerMonth: Use; % Amount of oil i used in month m

% Constraints
constraint forall(i in 1..I, m in 1..M) (
  if m = 1 then
    Buy[i, m] + InitialAmount = Use[i, m] + Store[i, m]
  else
    Buy[i, m] + Store[i, m - 1] = Use[i, m] + Store[i, m]
  endif
);

constraint forall(m in 1..M) (
  sum(i in 1..I where IsVegetable[i])(Use[i, m]) <= MaxVegRefiningPerMonth /\
  sum(i in 1..I where not IsVegetable[i])(Use[i, m]) <= MaxNonVegRefiningPerMonth
);

constraint forall(i in 1..I, m in 1..M) (
  if Use[i, m] > 0 then
    Use[i, m] >= MinUsage /\
    forall(j in 1..I where Dependencies[i, j])(Use[j, m] >= MinUsage)
  endif
);

constraint forall(m in 1..M) (
  sum(i in 1..I)(Hardness[i] * Use[i, m]) / sum(i in 1..I)(Use[i, m]) >= MinHardness /\
  sum(i in 1..I)(Hardness[i] * Use[i, m]) / sum(i in 1..I)(Use[i, m]) <= MaxHardness
);

% Objective
var int: Profit = sum(i in 1..I, m in 1..M)(SellPrice * Use[i, m] - BuyPrice[i, m] * Buy[i, m] - StorageCost * Store[i, m]);
solve maximize Profit;