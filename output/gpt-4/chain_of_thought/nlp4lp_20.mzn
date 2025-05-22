% Parameters
int: I; % Number of types of oil
int: M; % Number of months
array[1..M, 1..I] of int: BuyPrice; % Buying price of oil i in month m
int: SellPrice; % Selling price of final product
array[1..I] of bool: IsVegetable; % Indicator whether good i is a vegetable oil or not
int: MaxVegRefiningPerMonth; % Maximum refining capacity for refinding vegetable oil per month
int: MaxNonVegRefiningPerMonth; % Maximum refining capacity for non-vegetable oil per month
int: StorageSize; % Storage capacity for raw oil
int: StorageCost; % Storage cost per unit per month
float: MaxHardness; % Maximum hardness of final product
float: MinHardness; % Minimum hardness of final product
array[1..I] of float: Hardness; % Hardness of good i
array[1..I] of int: InitialAmount; % Initial amount of oil of each type that's available for processing
int: MinUsage; % If an oil is used in a month, at least MinUsage tons must be used.
array[1..I, 1..I] of int: Dependencies; % Dependencies of goods i as a binary table

% Variables
array[1..M, 1..I] of var 0..StorageSize: Buy; % Amount of oil i bought in month m
array[1..M, 1..I] of var 0..StorageSize: Store; % Amount of oil i stored in month m
array[1..M, 1..I] of var 0..MaxVegRefiningPerMonth + MaxNonVegRefiningPerMonth: Use; % Amount of oil i used in month m

% Constraints
constraint forall(m in 1..M, i in 1..I) (
  if m > 1 then
    Store[m, i] = Store[m-1, i] + Buy[m, i] - Use[m, i]
  else
    Store[m, i] = InitialAmount[i] + Buy[m, i] - Use[m, i]
  endif
);

constraint forall(m in 1..M) (
  sum(i in 1..I where IsVegetable[i]) (Use[m, i]) <= MaxVegRefiningPerMonth /\
  sum(i in 1..I where not IsVegetable[i]) (Use[m, i]) <= MaxNonVegRefiningPerMonth
);

constraint forall(m in 1..M) (
  sum(i in 1..I) (Use[m, i] * Hardness[i]) / sum(i in 1..I) (Use[m, i]) >= MinHardness /\
  sum(i in 1..I) (Use[m, i] * Hardness[i]) / sum(i in 1..I) (Use[m, i]) <= MaxHardness
);

constraint forall(m in 1..M, i in 1..I) (
  if Use[m, i] > 0 then
    Use[m, i] >= MinUsage /\
    forall(j in 1..I where Dependencies[i, j] == 1) (Use[m, j] >= MinUsage)
  endif
);

constraint forall(i in 1..I) (
  Store[M, i] = InitialAmount[i]
);

% Objective
var int: Profit = sum(m in 1..M, i in 1..I) (SellPrice * Use[m, i] - BuyPrice[m, i] * Buy[m, i] - StorageCost * Store[m, i]);
solve maximize Profit;