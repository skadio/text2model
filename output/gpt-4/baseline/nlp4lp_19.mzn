include "globals.mzn";

% Parameters
int: M; % Number of months
int: I; % Number of different oils
array[1..M, 1..I] of int: BuyPrice; % Buy price of oil i in month m
int: SellPrice; % Sell price of the products after refining
array[1..I] of bool: IsVegetable; % Indicator whether item i is a vegetable oil
int: MaxVegetableRefiningPerMonth; % Total refining capability for vegetable oils per month
int: MaxNonVegetableRefiningPerMonth; % Total refining capability for non-vegetable oils per month
int: StorageSize; % Storage capacity for raw oil
int: StorageCost; % Cost for storing oil per month per ton
int: MaxHardness; % The maximum hardness allowed for the products after refining
int: MinHardness; % The minimum hardness required for the products after refining
array[1..I] of float: Hardness; % Hardness of item i
int: InitialAmount; % Initial amount of items in storage at the beginning of the planning horizon

% Decision variables
array[1..M, 1..I] of var 0..StorageSize: Buy; % Amount of oil i to buy in month m
array[1..M, 1..I] of var 0..StorageSize: Store; % Amount of oil i to store in month m
array[1..M, 1..I] of var 0..MaxVegetableRefiningPerMonth + MaxNonVegetableRefiningPerMonth: Refine; % Amount of oil i to refine in month m

% Objective: Maximize profit
var int: Profit;
constraint Profit = sum(m in 1..M, i in 1..I) ((SellPrice - BuyPrice[m,i] - StorageCost) * Refine[m,i]) - sum(m in 1..M, i in 1..I) (BuyPrice[m,i] * Buy[m,i]);
solve maximize Profit;

% Constraints
constraint forall(m in 1..M) (
  sum(i in 1..I) (Buy[m,i] + if m > 1 then Store[m-1,i] else InitialAmount endif - Store[m,i] - Refine[m,i]) = 0
);
constraint forall(m in 1..M) (
  sum(i in 1..I) (IsVegetable[i] * Refine[m,i]) <= MaxVegetableRefiningPerMonth,
  sum(i in 1..I) ((not IsVegetable[i]) * Refine[m,i]) <= MaxNonVegetableRefiningPerMonth
);
constraint forall(m in 1..M) (
  sum(i in 1..I) (Hardness[i] * Refine[m,i]) / sum(i in 1..I) (Refine[m,i]) >= MinHardness,
  sum(i in 1..I) (Hardness[i] * Refine[m,i]) / sum(i in 1..I) (Refine[m,i]) <= MaxHardness
);
constraint forall(i in 1..I) (Store[M,i] = InitialAmount);