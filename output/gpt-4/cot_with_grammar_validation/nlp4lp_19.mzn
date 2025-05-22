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

% Variables
array[1..M, 1..I] of var 0..StorageSize: Buy; % Amount of oil i bought in month m
array[1..M, 1..I] of var 0..StorageSize: Store; % Amount of oil i stored in month m
array[1..M, 1..I] of var 0..max(MaxVegetableRefiningPerMonth, MaxNonVegetableRefiningPerMonth): Refine; % Amount of oil i refined in month m
array[1..M] of var 0..sum(i in 1..I)(Refine[m,i]): Produce; % Amount of product produced in month m

% Constraints
constraint forall(m in 1..M, i in 1..I)(Buy[m,i] + if m > 1 then Store[m-1,i] else InitialAmount endif == Refine[m,i] + Store[m,i]);
constraint forall(m in 1..M)(sum(i in 1..I where IsVegetable[i])(Refine[m,i]) <= MaxVegetableRefiningPerMonth);
constraint forall(m in 1..M)(sum(i in 1..I where not IsVegetable[i])(Refine[m,i]) <= MaxNonVegetableRefiningPerMonth);
constraint forall(m in 1..M)(sum(i in 1..I)(Store[m,i]) <= StorageSize);
constraint forall(m in 1..M)(sum(i in 1..I)(Refine[m,i]) == Produce[m]);
constraint forall(m in 1..M)(sum(i in 1..I)(Refine[m,i]*Hardness[i])/Produce[m] >= MinHardness);
constraint forall(m in 1..M)(sum(i in 1..I)(Refine[m,i]*Hardness[i])/Produce[m] <= MaxHardness);
constraint forall(i in 1..I)(Store[M,i] == InitialAmount);

% Objective
var int: Profit = sum(m in 1..M)(SellPrice*Produce[m] - sum(i in 1..I)(BuyPrice[m,i]*Buy[m,i] + StorageCost*Store[m,i]));
solve maximize Profit;