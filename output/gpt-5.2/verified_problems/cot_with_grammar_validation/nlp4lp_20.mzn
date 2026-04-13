int: I;
int: M;

array[1..M, 1..I] of int: BuyPrice;
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

array[1..I, 1..M] of var 0..StorageSize: Buy;
array[1..I, 1..M] of var 0..StorageSize: Use;
array[1..I, 1..M] of var 0..StorageSize: Stock;

array[1..I, 1..M] of var bool: Used;

constraint
  forall(i in 1..I, m in 1..M) (
    Used[i,m] <-> (Use[i,m] > 0)
  );

constraint
  forall(i in 1..I) (
    Stock[i,1] = InitialAmount + Buy[i,1] - Use[i,1]
  );

constraint
  forall(i in 1..I, m in 2..M) (
    Stock[i,m] = Stock[i,m-1] + Buy[i,m] - Use[i,m]
  );

constraint
  forall(i in 1..I) (
    Stock[i,M] = InitialAmount
  );

constraint
  forall(m in 1..M) (
    sum(i in 1..I)(Stock[i,m]) <= StorageSize
  );

constraint
  forall(m in 1..M) (
    sum(i in 1..I where IsVegetable[i])(Use[i,m]) <= MaxVegRefiningPerMonth
  );

constraint
  forall(m in 1..M) (
    sum(i in 1..I where not IsVegetable[i])(Use[i,m]) <= MaxNonVegRefiningPerMonth
  );

constraint
  forall(m in 1..M) (
    sum(i in 1..I)(bool2int(Used[i,m])) <= 3
  );

constraint
  forall(i in 1..I, m in 1..M) (
    Use[i,m] >= MinUsage * bool2int(Used[i,m])
  );

constraint
  forall(m in 1..M, i in 1..I, j in 1..I where Dependencies[i,j] = 1) (
    bool2int(Used[i,m]) <= bool2int(Used[j,m])
  );

constraint
  forall(m in 1..M) (
    sum(i in 1..I)(Hardness[i] * int2float(Use[i,m])) <=
      MaxHardness * int2float(sum(i in 1..I)(Use[i,m]))
  );

constraint
  forall(m in 1..M) (
    sum(i in 1..I)(Hardness[i] * int2float(Use[i,m])) >=
      MinHardness * int2float(sum(i in 1..I)(Use[i,m]))
  );

var float: Profit =
  sum(m in 1..M)(
    int2float(SellPrice) * int2float(sum(i in 1..I)(Use[i,m]))
    - sum(i in 1..I)(int2float(BuyPrice[m,i]) * int2float(Buy[i,m]))
    - int2float(StorageCost) * int2float(sum(i in 1..I)(Stock[i,m]))
  );

solve maximize Profit;