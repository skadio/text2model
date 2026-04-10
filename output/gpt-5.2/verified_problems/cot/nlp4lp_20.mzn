% Parameters
int: I;
int: M;

array[1..I, 1..M] of int: BuyPrice;
int: SellPrice;

array[1..I] of bool: IsVegetable;

int: MaxVegRefiningPerMonth;
int: MaxNonVegRefiningPerMonth;

int: StorageSize;
int: StorageCost;

float: MaxHardness;
float: MinHardness;
array[1..I] of float: Hardness;

int: InitialAmount;

int: MinUsage;

array[1..I, 1..I] of int: Dependencies;

% Variables
int: MaxFlow = StorageSize + max(MaxVegRefiningPerMonth, MaxNonVegRefiningPerMonth) + InitialAmount;

array[1..I, 1..M] of var 0..MaxFlow: buy;
array[1..I, 1..M] of var 0..MaxFlow: refine;
array[1..I, 0..M] of var 0..StorageSize: store;

array[1..I, 1..M] of var bool: use;

var int: profit;

% Constraints
% Initial and final storage requirements
constraint forall(i in 1..I) (
  store[i,0] = InitialAmount
);

constraint forall(i in 1..I) (
  store[i,M] = InitialAmount
);

% Inventory balance: only raw oil can be stored
constraint forall(i in 1..I, m in 1..M) (
  store[i,m] = store[i,m-1] + buy[i,m] - refine[i,m]
);

% Storage capacity (total across all oils)
constraint forall(m in 0..M) (
  sum(i in 1..I)(store[i,m]) <= StorageSize
);

% Refining capacity by line (veg / non-veg)
constraint forall(m in 1..M) (
  sum(i in 1..I where IsVegetable[i])(refine[i,m]) <= MaxVegRefiningPerMonth
);

constraint forall(m in 1..M) (
  sum(i in 1..I where not IsVegetable[i])(refine[i,m]) <= MaxNonVegRefiningPerMonth
);

% Link usage indicators and minimum usage
constraint forall(i in 1..I, m in 1..M) (
  refine[i,m] <= MaxFlow * bool2int(use[i,m])
);

constraint forall(i in 1..I, m in 1..M) (
  refine[i,m] >= MinUsage * bool2int(use[i,m])
);

% At most three oils used per month
constraint forall(m in 1..M) (
  sum(i in 1..I)(bool2int(use[i,m])) <= 3
);

% Dependencies: if i is used then j must also be used (when Dependencies[i,j] = 1)
constraint forall(m in 1..M, i in 1..I, j in 1..I where Dependencies[i,j] = 1) (
  bool2int(use[i,m]) <= bool2int(use[j,m])
);

% Hardness constraints (weighted average):
% MinHardness <= (sum_i refine[i,m]*Hardness[i]) / (sum_i refine[i,m]) <= MaxHardness
% Linearized:
% sum_i refine[i,m]*Hardness[i] >= MinHardness * sum_i refine[i,m]
% sum_i refine[i,m]*Hardness[i] <= MaxHardness * sum_i refine[i,m]
constraint forall(m in 1..M) (
  sum(i in 1..I)(int2float(refine[i,m]) * Hardness[i]) >= MinHardness * sum(i in 1..I)(int2float(refine[i,m]))
);

constraint forall(m in 1..M) (
  sum(i in 1..I)(int2float(refine[i,m]) * Hardness[i]) <= MaxHardness * sum(i in 1..I)(int2float(refine[i,m]))
);

% Profit definition:
% Revenue = SellPrice * total refined (no loss)
% Costs   = sum BuyPrice*buy + StorageCost * sum store (end-of-month storage)
constraint
  profit =
    SellPrice * sum(m in 1..M, i in 1..I)(refine[i,m])
    - sum(m in 1..M, i in 1..I)(BuyPrice[i,m] * buy[i,m])
    - StorageCost * sum(m in 1..M, i in 1..I)(store[i,m]);

% Objective
solve maximize profit;