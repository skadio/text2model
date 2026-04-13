int: M;
int: I;

set of int: MONTHS = 1..M;
set of int: OILS = 1..I;

array[OILS, MONTHS] of int: BuyPrice;
int: SellPrice;

array[OILS] of bool: IsVegetable;

int: MaxVegetableRefiningPerMonth;
int: MaxNonVegetableRefiningPerMonth;

int: StorageSize;
int: StorageCost;

float: MaxHardness;
float: MinHardness;
array[OILS] of float: Hardness;

int: InitialAmount;

array[MONTHS, OILS] of var 0..StorageSize: buy;
array[MONTHS, OILS] of var 0..StorageSize: refine;
array[0..M, OILS] of var 0..StorageSize: store;

array[MONTHS] of var 0..(MaxVegetableRefiningPerMonth + MaxNonVegetableRefiningPerMonth): prod;

constraint forall(i in OILS) (
  store[0,i] = InitialAmount
);

constraint forall(i in OILS) (
  store[M,i] = InitialAmount
);

constraint forall(m in MONTHS, i in OILS) (
  store[m,i] = store[m-1,i] + buy[m,i] - refine[m,i]
);

constraint forall(m in 0..M) (
  sum(i in OILS)(store[m,i]) <= StorageSize
);

constraint forall(m in MONTHS) (
  sum(i in OILS where IsVegetable[i])(refine[m,i]) <= MaxVegetableRefiningPerMonth
);

constraint forall(m in MONTHS) (
  sum(i in OILS where not IsVegetable[i])(refine[m,i]) <= MaxNonVegetableRefiningPerMonth
);

constraint forall(m in MONTHS) (
  prod[m] = sum(i in OILS)(refine[m,i])
);

constraint forall(m in MONTHS) (
  (prod[m] = 0) \/
  (
    sum(i in OILS)(Hardness[i] * int2float(refine[m,i])) <= MaxHardness * int2float(prod[m])
    /\
    sum(i in OILS)(Hardness[i] * int2float(refine[m,i])) >= MinHardness * int2float(prod[m])
  )
);

var float: revenue =
  sum(m in MONTHS)(int2float(SellPrice) * int2float(prod[m]));

var float: buy_cost =
  sum(m in MONTHS, i in OILS)(int2float(BuyPrice[i,m]) * int2float(buy[m,i]));

var float: storage_cost =
  sum(m in MONTHS, i in OILS)(int2float(StorageCost) * int2float(store[m,i]));

solve maximize (revenue - buy_cost - storage_cost);