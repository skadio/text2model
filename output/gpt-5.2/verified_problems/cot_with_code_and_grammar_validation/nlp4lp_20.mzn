int: I;
int: M;

set of int: OILS = 1..I;
set of int: MONTHS = 1..M;
set of int: MONTHS0 = 0..M;

array[MONTHS, OILS] of int: BuyPrice;
int: SellPrice;

array[OILS] of bool: IsVegetable;

int: MaxVegRefiningPerMonth;
int: MaxNonVegRefiningPerMonth;

int: StorageSize;
int: StorageCost;

float: MaxHardness;
float: MinHardness;
array[OILS] of float: Hardness;

int: InitialAmount;

int: MinUsage;

array[OILS, OILS] of int: Dependencies;

int: MaxRefinePerMonth = MaxVegRefiningPerMonth + MaxNonVegRefiningPerMonth;
int: MaxBuy = StorageSize;

array[OILS, MONTHS] of var 0..MaxBuy: buy;
array[OILS, MONTHS] of var 0..MaxRefinePerMonth: refine;
array[OILS, MONTHS0] of var 0..StorageSize: store;

array[OILS, MONTHS] of var bool: use;
array[MONTHS] of var 0..MaxRefinePerMonth: prod;

constraint forall(i in OILS) (store[i,0] = InitialAmount);
constraint forall(i in OILS) (store[i,M] = InitialAmount);

constraint forall(i in OILS, m in MONTHS) (
  store[i,m] = store[i,m-1] + buy[i,m] - refine[i,m]
);

constraint forall(m in MONTHS0) (
  sum(i in OILS)(store[i,m]) <= StorageSize
);

constraint forall(m in MONTHS) (
  sum(i in OILS where IsVegetable[i])(refine[i,m]) <= MaxVegRefiningPerMonth
);
constraint forall(m in MONTHS) (
  sum(i in OILS where not IsVegetable[i])(refine[i,m]) <= MaxNonVegRefiningPerMonth
);

constraint forall(i in OILS, m in MONTHS) (
  refine[i,m] <= MaxRefinePerMonth * bool2int(use[i,m])
);
constraint forall(i in OILS, m in MONTHS) (
  refine[i,m] >= MinUsage * bool2int(use[i,m])
);
constraint forall(m in MONTHS) (
  sum(i in OILS)(bool2int(use[i,m])) <= 3
);

constraint forall(m in MONTHS, i in OILS, j in OILS where Dependencies[i,j] = 1) (
  bool2int(use[i,m]) <= bool2int(use[j,m])
);

constraint forall(m in MONTHS) (
  prod[m] = sum(i in OILS)(refine[i,m])
);

constraint forall(m in MONTHS) (
  (prod[m] = 0) \/
  (
    MinHardness * int2float(prod[m]) <= sum(i in OILS)(int2float(refine[i,m]) * Hardness[i]) /\
    sum(i in OILS)(int2float(refine[i,m]) * Hardness[i]) <= MaxHardness * int2float(prod[m])
  )
);

var float: Revenue =
  int2float(SellPrice) * sum(m in MONTHS)(int2float(prod[m]));

var float: PurchaseCost =
  sum(i in OILS, m in MONTHS)(int2float(BuyPrice[m,i]) * int2float(buy[i,m]));

var float: HoldingCost =
  int2float(StorageCost) * sum(m in MONTHS, i in OILS)(int2float(store[i,m]));

solve maximize (Revenue - PurchaseCost - HoldingCost);