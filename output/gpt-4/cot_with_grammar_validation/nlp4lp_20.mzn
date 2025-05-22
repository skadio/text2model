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
int: MaxHardness; % Maximum hardness of final product
int: MinHardness; % Minimum hardness of final product
array[1..I] of float: Hardness; % Hardness of good i
int: InitialAmount; % Initial amount of oil of each type that's available for processing
int: MinUsage; % If an oil is used in a month, at least MinUsage tons must be used.
array[1..I, 1..I] of bool: Dependencies; % Dependencies of goods i as a binary table

% Variables
array[1..M, 1..I] of var 0..StorageSize: Buy; % Amount of oil i bought in month m
array[1..M, 1..I] of var 0..StorageSize: Store; % Amount of oil i stored in month m
array[1..M, 1..I] of var 0..MaxVegRefiningPerMonth + MaxNonVegRefiningPerMonth: Produce; % Amount of oil i produced in month m

% Constraints
constraint forall(m in 1..M, i in 1..I) (
  if m == 1 then
    Buy[m,i] + InitialAmount == Produce[m,i] + Store[m,i]
  else
    Buy[m,i] + Store[m-1,i] == Produce[m,i] + Store[m,i]
  endif
);

constraint forall(m in 1..M) (
  sum(i in 1..I where IsVegetable[i]) (Produce[m,i]) <= MaxVegRefiningPerMonth /\
  sum(i in 1..I where not IsVegetable[i]) (Produce[m,i]) <= MaxNonVegRefiningPerMonth
);

constraint forall(m in 1..M) (
  sum(i in 1..I) (Store[m,i]) <= StorageSize
);

constraint forall(m in 1..M) (
  sum(i in 1..I) (Produce[m,i] * Hardness[i]) / sum(i in 1..I) (Produce[m,i]) >= MinHardness /\
  sum(i in 1..I) (Produce[m,i] * Hardness[i]) / sum(i in 1..I) (Produce[m,i]) <= MaxHardness
);

constraint forall(m in 1..M, i in 1..I) (
  if Produce[m,i] > 0 then
    Produce[m,i] >= MinUsage /\
    forall(j in 1..I) (
      if Dependencies[i,j] then
        Produce[m,j] >= MinUsage
      endif
    )
  endif
);

% Objective
var int: Profit = sum(m in 1..M, i in 1..I) (SellPrice * Produce[m,i] - BuyPrice[m,i] * Buy[m,i] - StorageCost * Store[m,i]);
solve maximize Profit;