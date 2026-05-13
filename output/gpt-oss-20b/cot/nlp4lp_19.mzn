% Parameters
int: M;
int: I;
array[1..M, 1..I] of int: BuyPrice;
int: SellPrice;
array[1..I] of bool: IsVegetable;
int: MaxVegetableRefiningPerMonth;
int: MaxNonVegetableRefiningPerMonth;
int: StorageSize;
int: StorageCost;
float: MaxHardness;
float: MinHardness;
array[1..I] of float: Hardness;
int: InitialAmount;

% Variables
var int: buy[1..I, 1..M];
var int: refine[1..I, 1..M];
var int: stock[1..I, 1..M];
var int: profit;

% Constraints
constraint
  % Initial stock and recurrence
  forall(i in 1..I) (
    stock[i,1] = InitialAmount + buy[i,1] - refine[i,1]
  ) /\
  forall(m in 2..M, i in 1..I) (
    stock[i,m] = stock[i,m-1] + buy[i,m] - refine[i,m]
  );

constraint
  % Non-negativity
  forall(i in 1..I, m in 1..M) (
    buy[i,m] >= 0 /\ refine[i,m] >= 0 /\ stock[i,m] >= 0
  );

constraint
  % Refining capacity
  forall(m in 1..M) (
    sum(i in 1..I where IsVegetable[i]) refine[i,m] <= MaxVegetableRefiningPerMonth /\
    sum(i in 1..I where not IsVegetable[i]) refine[i,m] <= MaxNonVegetableRefiningPerMonth
  );

constraint
  % Storage capacity
  forall(m in 1..M) (
    sum(i in 1..I) stock[i,m] <= StorageSize
  );

constraint
  % Hardness constraints
  forall(m in 1..M) (
    let {
      int total = sum(i in 1..I) refine[i,m];
      int totalCost = sum(i in 1..I) BuyPrice[m,i] * buy[i,m];
      int totalStock = sum(i in 1..I) stock[i,m];
    } in
    let {
      int totalCostPerUnit = totalCost / total;
      int totalStockPerUnit = totalStock / total;
    } in
    totalCostPerUnit <= totalStockPerUnit
  );

constraint
  % Profit definition
  profit = sum(m in 1..M, i in 1..I) refine[i,m] -
           sum(m in 1..M, i in 1..I) BuyPrice[m,i] * buy[i,m] -
           StorageCost * sum(m in 1..M, i in 1..I) stock[i,m];

% Objective
solve maximize profit;