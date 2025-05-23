% Parameters
int: M; % Number of months
int: I; % Number of different oils
array[1..I, 1..M] of int: BuyPrice; % Buy price of oil i in month m
int: SellPrice; % Sell price of the products after refining
array[1..I] of bool: IsVegetable; % Indicator whether item i is a vegetable oil
int: MaxVegetableRefiningPerMonth; % Total refining capability for vegetable oils per month
int: MaxNonVegetableRefiningPerMonth; % Total refining capability for non-vegetable oils per month
int: StorageSize; % Storage capacity for raw oil
int: StorageCost; % Cost for storing oil per month per ton
int: MaxHardness; % The maximum hardness allowed for the products after refining
int: MinHardness; % The minimum hardness required for the products after refining
array[1..I] of float: Hardness; % Hardness of item i
array[1..I] of int: InitialAmount; % Initial amount of items in storage at the beginning of the planning horizon

% Variables
array[1..I, 1..M] of var 0..StorageSize: Buy; % Amount of oil i bought in month m
array[1..I, 1..M] of var 0..StorageSize: Store; % Amount of oil i stored in month m
array[1..I, 1..M] of var 0..max(MaxVegetableRefiningPerMonth, MaxNonVegetableRefiningPerMonth): Refine; % Amount of oil i refined in month m
array[1..M] of var 0..sum([max(MaxVegetableRefiningPerMonth, MaxNonVegetableRefiningPerMonth) * I | i in 1..I]): TotalRefined; % Total amount of oil refined in month m

% Constraints
constraint forall(i in 1..I, m in 1..M) (
  if m = 1 then
    Store[i, m] = InitialAmount[i] + Buy[i, m] - Refine[i, m]
  else
    Store[i, m] = Store[i, m-1] + Buy[i, m] - Refine[i, m]
  endif
);

constraint forall(m in 1..M) (
  sum(i in 1..I) (IsVegetable[i] * Refine[i, m]) <= MaxVegetableRefiningPerMonth
  /\ sum(i in 1..I) ((1 - IsVegetable[i]) * Refine[i, m]) <= MaxNonVegetableRefiningPerMonth
);

constraint forall(m in 1..M) (
  sum(i in 1..I) (Store[i, m]) <= StorageSize
);

constraint forall(m in 1..M) (
  TotalRefined[m] = sum(i in 1..I) (Refine[i, m])
  /\ sum(i in 1..I) (Hardness[i] * Refine[i, m]) / TotalRefined[m] >= MinHardness
  /\ sum(i in 1..I) (Hardness[i] * Refine[i, m]) / TotalRefined[m] <= MaxHardness
);

constraint forall(i in 1..I) (
  Store[i, M] = InitialAmount[i]
);

% Objective
var int: Profit = sum(i in 1..I, m in 1..M) ((SellPrice - BuyPrice[i, m]) * Refine[i, m] - StorageCost * Store[i, m]);
solve maximize Profit;