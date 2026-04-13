% Parameters
int: I; % number of oil types
int: M; % number of months

set of int: OILS = 1..I;
set of int: MONTHS = 1..M;

% NOTE: data may be provided as array2d(1..M,1..I,...) in .dzn.
% Declare as [MONTHS,OILS] to match the typical array2d example given.
array[MONTHS, OILS] of int: BuyPrice; % buying price in month m for oil i

int: SellPrice; % selling price per ton of final product

array[OILS] of bool: IsVegetable; % true if oil i is vegetable

int: MaxVegRefiningPerMonth;    % max tons of vegetable oils that can be refined per month
int: MaxNonVegRefiningPerMonth; % max tons of non-vegetable oils that can be refined per month

int: StorageSize; % max total tons of raw oil that can be stored (across all oils)
int: StorageCost; % storage cost per ton per month

float: MaxHardness; % maximum allowed hardness of final product
float: MinHardness; % minimum allowed hardness of final product
array[OILS] of float: Hardness; % hardness of oil i

int: InitialAmount; % initial amount (tons) of each oil type in storage (same for all i)
int: MinUsage; % if oil i is used in a month, must use at least this many tons

array[OILS, OILS] of int: Dependencies;
% Dependencies[i,j] = 1 => if oil i is used then oil j must also be used


% Variables
array[OILS, MONTHS] of var 0..StorageSize: buy;
array[OILS, MONTHS] of var 0..StorageSize: refine;

array[OILS, 0..M] of var 0..StorageSize: stock;

array[OILS, MONTHS] of var bool: used;

array[MONTHS] of var 0..(StorageSize * I): produce;

var int: profit;


% Constraints
constraint
  forall(i in OILS) (
    stock[i,0] = InitialAmount
  );

constraint
  forall(i in OILS, m in MONTHS) (
    stock[i,m] = stock[i,m-1] + buy[i,m] - refine[i,m]
  );

constraint
  forall(m in 0..M) (
    sum(i in OILS)(stock[i,m]) <= StorageSize
  );

constraint
  forall(i in OILS) (
    stock[i,M] = stock[i,0]
  );

constraint
  forall(m in MONTHS) (
    sum(i in OILS where IsVegetable[i])(refine[i,m]) <= MaxVegRefiningPerMonth
  );

constraint
  forall(m in MONTHS) (
    sum(i in OILS where not IsVegetable[i])(refine[i,m]) <= MaxNonVegRefiningPerMonth
  );

constraint
  forall(m in MONTHS) (
    produce[m] = sum(i in OILS)(refine[i,m])
  );

% Link usage to refining and enforce minimum usage if used
constraint
  forall(i in OILS, m in MONTHS) (
    refine[i,m] <= StorageSize * bool2int(used[i,m])
  );

constraint
  forall(i in OILS, m in MONTHS) (
    refine[i,m] >= MinUsage * bool2int(used[i,m])
  );

constraint
  forall(m in MONTHS) (
    sum(i in OILS)(bool2int(used[i,m])) <= 3
  );

constraint
  forall(m in MONTHS, i in OILS, j in OILS where Dependencies[i,j] = 1) (
    bool2int(used[i,m]) <= bool2int(used[j,m])
  );

% Hardness constraints (skip if no production)
constraint
  forall(m in MONTHS) (
    produce[m] = 0 \/
    (
      sum(i in OILS)(Hardness[i] * int2float(refine[i,m])) >= MinHardness * int2float(produce[m])
      /\
      sum(i in OILS)(Hardness[i] * int2float(refine[i,m])) <= MaxHardness * int2float(produce[m])
    )
  );

% Objective
constraint
  profit =
    sum(m in MONTHS)(SellPrice * produce[m])
    - sum(i in OILS, m in MONTHS)(BuyPrice[m,i] * buy[i,m])
    - sum(i in OILS, m in MONTHS)(StorageCost * stock[i,m]);

solve maximize profit;