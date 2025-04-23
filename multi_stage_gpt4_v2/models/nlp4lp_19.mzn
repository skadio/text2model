% Parameters
int: M; % Number of months
int: I; % Number of different oils
array[1..I, 1..M] of float: BuyPrice; % Buy price of oil i in month m
float: SellPrice; % Sell price of the products after refining
array[1..I] of bool: IsVegetable; % Indicator whether item i is a vegetable oil
float: MaxVegetableRefiningPerMonth; % Total refining capability for vegetable oils per month
float: MaxNonVegetableRefiningPerMonth; % Total refining capability for non-vegetable oils per month
float: StorageSize; % Storage capacity for raw oil
float: StorageCost; % Cost for storing oil per month per ton
float: MaxHardness; % The maximum hardness allowed for the products after refining
float: MinHardness; % The minimum hardness required for the products after refining
array[1..I] of float: Hardness; % Hardness of item i
array[1..I] of float: InitialAmount; % Initial amount of items in storage at the beginning of the planning horizon

% Variables
array[1..I, 1..M] of var 0..StorageSize: Buy; % Amount of oil i to buy in month m
array[1..I, 1..M] of var 0..StorageSize: Store; % Amount of oil i to store in month m
array[1..I, 1..M] of var 0..max(MaxVegetableRefiningPerMonth, MaxNonVegetableRefiningPerMonth): Refine; % Amount of oil i to refine in month m
var 0..max(MaxVegetableRefiningPerMonth, MaxNonVegetableRefiningPerMonth)*M: TotalRefined; % Total amount of oil refined over all months
var MinHardness..MaxHardness: FinalProductHardness; % Hardness of the final product

% Constraints

% The total amount of oil refined over all months and all oil types must be equal to TotalRefined
constraint TotalRefined = sum(m in 1..M, i in 1..I) (Refine[i,m]);

% The hardness of the final product must be the weighted average of the hardness of each oil it is made with
constraint FinalProductHardness = sum(i in 1..I, m in 1..M) (Hardness[i] * Refine[i,m]) / TotalRefined;

% The total amount of vegetable oil refined in any month cannot exceed the maximum refining capability for vegetable oils
constraint forall(m in 1..M) (
    sum(i in 1..I) (IsVegetable[i] * Refine[i,m]) <= MaxVegetableRefiningPerMonth
);

% The total amount of non-vegetable oil refined in any month cannot exceed the maximum refining capability for non-vegetable oils
constraint forall(m in 1..M) (
    sum(i in 1..I) ((1 - IsVegetable[i]) * Refine[i,m]) <= MaxNonVegetableRefiningPerMonth
);

% The total amount of oil stored in any month cannot exceed the storage capacity
constraint forall(m in 1..M) (
    sum(i in 1..I) (Store[i,m]) <= StorageSize
);

% The amount of oil stored in the first month is the initial amount plus the amount bought minus the amount refined
constraint forall(i in 1..I) (
    Store[i,1] = InitialAmount[i] + Buy[i,1] - Refine[i,1]
);

% The amount of oil stored in any month (except the first) is the amount stored in the previous month plus the amount bought minus the amount refined
constraint forall(i in 1..I, m in 2..M) (
    Store[i,m] = Store[i,m-1] + Buy[i,m] - Refine[i,m]
);

% The amount of oil stored in the last month must be equal to the initial amount
constraint forall(i in 1..I) (
    Store[i,M] = InitialAmount[i]
);

% Objective
solve maximize TotalRefined * SellPrice - sum(i in 1..I, m in 1..M) (Buy[i,m] * BuyPrice[i,m] + Store[i,m] * StorageCost);