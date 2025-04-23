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
float: InitialAmount; % Initial amount of items in storage at the beginning of the planning horizon

% Variables
array[1..I, 1..M] of var 0..StorageSize: Buy; % Amount of oil i to buy in month m
array[1..I, 1..M] of var 0..StorageSize: Store; % Amount of oil i to store in month m
array[1..I, 1..M] of var 0..max(MaxVegetableRefiningPerMonth, MaxNonVegetableRefiningPerMonth): Refine; % Amount of oil i to refine in month m
var 0..max(MaxVegetableRefiningPerMonth, MaxNonVegetableRefiningPerMonth)*M: TotalRefined; % Total amount of oil refined over all months
var float: Profit; % Total profit

% Constraints

% The total amount of oil refined over all months is the sum of all refined oils
constraint TotalRefined = sum(i in 1..I, m in 1..M)(Refine[i,m]);

% The total profit is the selling price of the total refined oil minus the cost of buying and storing the oil
constraint Profit = SellPrice * TotalRefined - sum(i in 1..I, m in 1..M)(BuyPrice[i,m] * Buy[i,m] + StorageCost * Store[i,m]);

% The amount of oil bought, stored, and refined in each month should not exceed the storage capacity
constraint forall(m in 1..M)(sum(i in 1..I)(Buy[i,m] + Store[i,m] + Refine[i,m]) <= StorageSize);

% The amount of oil refined in each month should not exceed the refining capacity
constraint forall(m in 1..M)(
    sum(i in 1..I where IsVegetable[i])(Refine[i,m]) <= MaxVegetableRefiningPerMonth,
    sum(i in 1..I where not IsVegetable[i])(Refine[i,m]) <= MaxNonVegetableRefiningPerMonth
);

% The hardness of the final product should be within the given range
constraint forall(m in 1..M)(
    sum(i in 1..I)(Hardness[i] * Refine[i,m]) / sum(i in 1..I)(Refine[i,m]) >= MinHardness,
    sum(i in 1..I)(Hardness[i] * Refine[i,m]) / sum(i in 1..I)(Refine[i,m]) <= MaxHardness
);

% The amount of oil in storage at the end of the last month should be the same as the initial amount
constraint sum(i in 1..I)(Store[i,M]) = InitialAmount;

% Objective
solve maximize Profit;