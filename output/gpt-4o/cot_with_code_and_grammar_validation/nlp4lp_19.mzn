int: M;
int: I;

set of int: Months = 1..M;
set of int: Oils   = 1..I;

array[Months, Oils] of float: BuyPrice;
float: SellPrice;

array[Oils] of bool: IsVegetable;
float: MaxVegetableRefiningPerMonth;
float: MaxNonVegetableRefiningPerMonth;

float: StorageSize;
float: StorageCost;

float: MaxHardness;
float: MinHardness;

array[Oils] of float: Hardness;

float: InitialAmount;

set of int: VegOils    = { i | i in Oils where IsVegetable[i] };
set of int: NonVegOils = { i | i in Oils where not IsVegetable[i] };

float: BigM = 1.0e6;

array[Months, Oils] of var 0.0..BigM: buy;
array[Months, Oils] of var 0.0..BigM: refine;
array[Months, Oils] of var 0.0..StorageSize: inventory;

constraint
  ( forall(i in Oils)(
      inventory[1,i] = InitialAmount + buy[1,i] - refine[1,i]
    )
  ) /\
  ( forall(m in 2..M, i in Oils)(
      inventory[m,i] = inventory[m-1,i] + buy[m,i] - refine[m,i]
    )
  );

constraint
  forall(m in Months)(
    sum(i in Oils)(inventory[m,i]) <= StorageSize
  );

constraint
  forall(m in Months)(
    sum(i in VegOils)(refine[m,i]) <= MaxVegetableRefiningPerMonth
  ) /\
  forall(m in Months)(
    sum(i in NonVegOils)(refine[m,i]) <= MaxNonVegetableRefiningPerMonth
  );

constraint
  forall(m in Months)(
    sum(i in Oils)(refine[m,i] * Hardness[i]) >= MinHardness * sum(i in Oils)(refine[m,i])
  ) /\
  forall(m in Months)(
    sum(i in Oils)(refine[m,i] * Hardness[i]) <= MaxHardness * sum(i in Oils)(refine[m,i])
  );

constraint
  forall(i in Oils)(
    inventory[M,i] = InitialAmount
  );

var float: profit =
      SellPrice * sum(m in Months, i in Oils)(refine[m,i])
    -             sum(m in Months, i in Oils)(BuyPrice[m,i] * buy[m,i])
    - StorageCost * sum(m in Months, i in Oils)(inventory[m,i]);

solve maximize profit;