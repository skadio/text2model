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

set of int: Months = 1..M;
set of int: Oils = 1..I;

array[Months, Oils] of var 0..StorageSize: Buy;
array[Months, Oils] of var 0..StorageSize: Refine;
array[0..M, Oils] of var 0..StorageSize: Stock;

var 0..(max(MaxVegetableRefiningPerMonth, MaxNonVegetableRefiningPerMonth) * M): TotalProduced;

constraint
  forall(i in Oils) (
    Stock[0,i] = InitialAmount
  );

constraint
  forall(m in Months, i in Oils) (
    Stock[m,i] = Stock[m-1,i] + Buy[m,i] - Refine[m,i]
  );

constraint
  forall(m in 0..M) (
    sum(i in Oils)(Stock[m,i]) <= StorageSize
  );

constraint
  forall(i in Oils) (
    Stock[M,i] = Stock[0,i]
  );

constraint
  forall(m in Months) (
    sum(i in Oils where IsVegetable[i])(Refine[m,i]) <= MaxVegetableRefiningPerMonth
  );

constraint
  forall(m in Months) (
    sum(i in Oils where not IsVegetable[i])(Refine[m,i]) <= MaxNonVegetableRefiningPerMonth
  );

constraint
  forall(m in Months) (
    let { var int: T = sum(i in Oils)(Refine[m,i]) } in
      (sum(i in Oils)(Hardness[i] * int2float(Refine[m,i])) >= MinHardness * int2float(T)) /\
      (sum(i in Oils)(Hardness[i] * int2float(Refine[m,i])) <= MaxHardness * int2float(T))
  );

constraint
  TotalProduced = sum(m in Months, i in Oils)(Refine[m,i]);

solve maximize
  sum(m in Months, i in Oils)(SellPrice * Refine[m,i])
  - sum(m in Months, i in Oils)(BuyPrice[m,i] * Buy[m,i])
  - sum(m in Months, i in Oils)(StorageCost * Stock[m,i]);