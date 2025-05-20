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
array[1..I] of int: Hardness; % Hardness of good i
int: InitialAmount; % Initial amount of oil of each type that's available for processing
int: MinUsage; % If an oil is used in a month, at least MinUsage tons must be used.
array[1..I, 1..I] of bool: Dependencies; % Dependencies of goods i

% Variables
array[1..I, 1..M] of var 0..StorageSize: Bought; % Amount of oil i bought in month m
array[1..I, 1..M] of var 0..StorageSize: Stored; % Amount of oil i stored in month m
array[1..I, 1..M] of var 0..MaxVegRefiningPerMonth + MaxNonVegRefiningPerMonth: Used; % Amount of oil i used in month m

% Constraints
constraint forall(i in 1..I, m in 1..M) (
  if m = 1 then
    Bought[i, m] + InitialAmount = Used[i, m] + Stored[i, m]
  else
    Bought[i, m] + Stored[i, m - 1] = Used[i, m] + Stored[i, m]
  endif
);

constraint forall(m in 1..M) (
  sum(i in 1..I where IsVegetable[i]) (Used[i, m]) <= MaxVegRefiningPerMonth /\
  sum(i in 1..I where not IsVegetable[i]) (Used[i, m]) <= MaxNonVegRefiningPerMonth
);

constraint forall(m in 1..M) (
  sum(i in 1..I) (Stored[i, m]) <= StorageSize
);

constraint forall(i in 1..I, m in 1..M) (
  if Used[i, m] > 0 then
    Used[i, m] >= MinUsage /\
    forall(j in 1..I where Dependencies[i, j]) (Used[j, m] >= MinUsage)
  endif
);

constraint forall(m in 1..M) (
  let {
    var float: total_hardness = sum(i in 1..I) (Used[i, m] * Hardness[i]) / sum(i in 1..I) (Used[i, m])
  } in
  total_hardness >= MinHardness /\ total_hardness <= MaxHardness
);

% Objective
var int: profit = sum(m in 1..M) (
  SellPrice * sum(i in 1..I) (Used[i, m]) - sum(i in 1..I) (BuyPrice[i, m] * Bought[i, m] + StorageCost * Stored[i, m])
);
solve maximize profit;

% Output
output [ "Profit: " ++ show(profit) ++ "\n" ] ++
[ if fix(Used[i, m]) > 0 then "Month " ++ show(m) ++ ", Oil " ++ show(i) ++ ": bought " ++ show(Bought[i, m]) ++ ", used " ++ show(Used[i, m]) ++ ", stored " ++ show(Stored[i, m]) ++ "\n" else "" endif | i in 1..I, m in 1..M ];