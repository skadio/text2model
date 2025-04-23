% Parameters
int: I; % Number of types of oil
int: M; % Number of months
array[1..I, 1..M] of int: BuyPrice; % Buying price of oil i in month m
int: SellPrice; % Selling price of final product
array[1..I] of 0..1: IsVegetable; % Indicator whether good i is a vegetable oil or not
int: MaxVegRefiningPerMonth; % Maximum refining capacity for refinding vegetable oil per month
int: MaxNonVegRefiningPerMonth; % Maximum refining capacity for non-vegetable oil per month
int: StorageSize; % Storage capacity for raw oil
int: StorageCost; % Storage cost per unit per month
int: MaxHardness; % Maximum hardness of final product
int: MinHardness; % Minimum hardness of final product
array[1..I] of int: Hardness; % Hardness of good i
array[1..I] of int: InitialAmount; % Initial amount of oil of each type that's available for processing
int: MinUsage; % If an oil is used in a month, at least MinUsage tons must be used
array[1..I, 1..I] of 0..1: Dependencies; % Dependencies of goods i as a binary table if Dependencies_{i, j}} is 1, then when oil i is used, oil j must also be used

% Variables
array[1..I, 1..M] of var 0..StorageSize: Buy; % Amount of oil i to buy in month m
array[1..I, 1..M] of var 0..StorageSize: Store; % Amount of oil i to store in month m
array[1..I, 1..M] of var 0..MaxVegRefiningPerMonth + MaxNonVegRefiningPerMonth: Refine; % Amount of oil i to refine in month m
array[1..I, 1..M] of var 0..1: UseOil; % Indicator whether oil i is used in month m or not

% Constraints

% The total amount of oil bought and stored in each month should not exceed the storage capacity
constraint forall(m in 1..M)(
  sum(i in 1..I)(Buy[i,m] + Store[i,m]) <= StorageSize
);

% The total amount of vegetable oil refined in each month should not exceed the maximum refining capacity for vegetable oil
constraint forall(m in 1..M)(
  sum(i in 1..I)(IsVegetable[i] * Refine[i,m]) <= MaxVegRefiningPerMonth
);

% The total amount of non-vegetable oil refined in each month should not exceed the maximum refining capacity for non-vegetable oil
constraint forall(m in 1..M)(
  sum(i in 1..I)((1 - IsVegetable[i]) * Refine[i,m]) <= MaxNonVegRefiningPerMonth
);

% The hardness of the final product in each month should be within the given range
constraint forall(m in 1..M)(
  sum(i in 1..I)(UseOil[i,m] * Hardness[i] * Refine[i,m]) / sum(i in 1..I)(UseOil[i,m] * Refine[i,m]) >= MinHardness
  /\ sum(i in 1..I)(UseOil[i,m] * Hardness[i] * Refine[i,m]) / sum(i in 1..I)(UseOil[i,m] * Refine[i,m]) <= MaxHardness
);

% The number of oils used in each month should not exceed 3
constraint forall(m in 1..M)(
  sum(i in 1..I)(UseOil[i,m]) <= 3
);

% If an oil is used in a month, at least MinUsage tons must be used
constraint forall(i in 1..I, m in 1..M)(
  UseOil[i,m] * MinUsage <= Refine[i,m]
);

% If an oil of a given type is used then another type must also be used
constraint forall(i in 1..I, m in 1..M)(
  sum(j in 1..I)(Dependencies[i,j] * UseOil[j,m]) >= UseOil[i,m]
);

% At the end of the last month, we still have the same amount of storage as we started with
constraint forall(i in 1..I)(
  Store[i,M] == InitialAmount[i]
);

% Objective
solve maximize sum(i in 1..I, m in 1..M)(SellPrice * Refine[i,m] - BuyPrice[i,m] * Buy[i,m] - StorageCost * Store[i,m]);