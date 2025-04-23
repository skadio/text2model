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
int: InitialAmount; % Initial amount of oil of each type that's available for processing
int: MinUsage; % If an oil is used in a month, at least MinUsage tons must be used
array[1..I, 1..I] of 0..1: Dependencies; % Dependencies of goods i as a binary table

% Variables
array[1..I, 1..M] of var 0..StorageSize: Buy; % Amount of oil i to buy in month m
array[1..I, 1..M] of var 0..StorageSize: Store; % Amount of oil i to store in month m
array[1..I, 1..M] of var 0..MaxVegRefiningPerMonth + MaxNonVegRefiningPerMonth: Refine; % Amount of oil i to refine in month m
array[1..M] of var MinHardness..MaxHardness: FinalProductHardness; % Hardness of final product in month m

% Constraints

% The amount of oil bought, stored and refined must be within the storage and refining capacities
constraint forall(i in 1..I, m in 1..M) (
    Buy[i, m] + Store[i, m] + Refine[i, m] <= StorageSize
);

% The amount of vegetable and non-vegetable oil refined in each month must not exceed the refining capacities
constraint forall(m in 1..M) (
    sum(i in 1..I where IsVegetable[i] = 1) (Refine[i, m]) <= MaxVegRefiningPerMonth,
    sum(i in 1..I where IsVegetable[i] = 0) (Refine[i, m]) <= MaxNonVegRefiningPerMonth
);

% The hardness of the final product in each month must be within the specified range
constraint forall(m in 1..M) (
    FinalProductHardness[m] >= MinHardness,
    FinalProductHardness[m] <= MaxHardness
);

% The hardness of the final product in each month is the weighted average of the hardness of the oils used
constraint forall(m in 1..M) (
    FinalProductHardness[m] = sum(i in 1..I) (Hardness[i] * Refine[i, m]) div sum(i in 1..I) (Refine[i, m])
);

% The amount of oil used in each month must meet the minimum usage criteria if it is used
constraint forall(i in 1..I, m in 1..M) (
    if Refine[i, m] > 0 then
        Refine[i, m] >= MinUsage
    else
        true
    endif
);

% If an oil is used in a month, the oils it depends on must also be used
constraint forall(i in 1..I, j in 1..I, m in 1..M) (
    if Dependencies[i, j] = 1 then
        if Refine[i, m] > 0 then
            Refine[j, m] > 0
        else
            true
        endif
    else
        true
    endif
);

% The amount of oil in storage at the end of the last month must be the same as the initial amount
constraint forall(i in 1..I) (
    Store[i, M] = InitialAmount
);

% The food may never be made up of more than three oils in any month
constraint forall(m in 1..M) (
    sum(i in 1..I) (bool2int(Refine[i, m] > 0)) <= 3
);

% Objective
solve maximize sum(i in 1..I, m in 1..M) (SellPrice * Refine[i, m] - BuyPrice[i, m] * Buy[i, m] - StorageCost * Store[i, m]);