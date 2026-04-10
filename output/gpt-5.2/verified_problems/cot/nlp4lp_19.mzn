% Parameters
int: M;
int: I;

set of int: Months = 1..M;
set of int: Oils = 1..I;

array[Months, Oils] of int: BuyPrice;          % price per ton
int: SellPrice;                                % revenue per ton refined/sold

array[Oils] of bool: IsVegetable;

int: MaxVegetableRefiningPerMonth;
int: MaxNonVegetableRefiningPerMonth;

int: StorageSize;                              % max total raw oil stored
int: StorageCost;                              % per ton per month

float: MaxHardness;
float: MinHardness;
array[Oils] of float: Hardness;

int: InitialAmount;                            % initial (and required final) amount per oil


% Variables
array[Months, Oils] of var 0..StorageSize: buy;        % tons bought in month m of oil i
array[Months, Oils] of var 0..StorageSize: refine;     % tons refined/used in month m of oil i
array[0..M, Oils] of var 0..StorageSize: store;        % tons in storage at end of month m (m=0 initial)

array[Months] of var 0..(MaxVegetableRefiningPerMonth + MaxNonVegetableRefiningPerMonth): prod; % total refined in month m

var int: profit;


% Constraints
% Initial and final storage per oil
constraint forall(i in Oils) (
  store[0, i] = InitialAmount
);
constraint forall(i in Oils) (
  store[M, i] = InitialAmount
);

% Inventory balance (raw oil only)
constraint forall(m in Months, i in Oils) (
  store[m, i] = store[m-1, i] + buy[m, i] - refine[m, i]
);

% Storage capacity (total across oils)
constraint forall(m in 0..M) (
  sum(i in Oils)(store[m, i]) <= StorageSize
);

% Refining capacities by type
constraint forall(m in Months) (
  sum(i in Oils where IsVegetable[i])(refine[m, i]) <= MaxVegetableRefiningPerMonth
);
constraint forall(m in Months) (
  sum(i in Oils where not IsVegetable[i])(refine[m, i]) <= MaxNonVegetableRefiningPerMonth
);

% Production definition
constraint forall(m in Months) (
  prod[m] = sum(i in Oils)(refine[m, i])
);

% Hardness constraints (weighted average), only when producing
constraint forall(m in Months) (
  prod[m] = 0 \/
  (
    sum(i in Oils)(Hardness[i] * int2float(refine[m, i])) <= MaxHardness * int2float(prod[m]) /\
    sum(i in Oils)(Hardness[i] * int2float(refine[m, i])) >= MinHardness * int2float(prod[m])
  )
);

% Profit (revenue - purchase cost - storage cost)
constraint profit =
  sum(m in Months)(SellPrice * prod[m])
  - sum(m in Months, i in Oils)(BuyPrice[m, i] * buy[m, i])
  - StorageCost * sum(m in Months, i in Oils)(store[m, i]);


% Objective
solve maximize profit;