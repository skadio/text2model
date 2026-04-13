int: N;
array[1..N] of float: Demand;

float: MaxRegularAmount;
float: CostRegular;
float: CostOvertime;
float: StoreCost;

set of int: T = 1..N;

array[T] of var float: RegularProd;
array[T] of var float: OvertimeProd;
array[T] of var float: Inventory;

constraint forall(t in T) (
  RegularProd[t] >= 0.0 /\ OvertimeProd[t] >= 0.0 /\ Inventory[t] >= 0.0
);

constraint forall(t in T) (
  RegularProd[t] <= MaxRegularAmount
);

constraint
  Inventory[1] = RegularProd[1] + OvertimeProd[1] - Demand[1];

constraint forall(t in 2..N) (
  Inventory[t] = Inventory[t-1] + RegularProd[t] + OvertimeProd[t] - Demand[t]
);

solve minimize
  sum(t in T) (
    CostRegular * RegularProd[t]
    + CostOvertime * OvertimeProd[t]
    + StoreCost * Inventory[t]
  );

output [
  "TotalCost=", show(
    sum(t in T) (
      CostRegular * RegularProd[t]
      + CostOvertime * OvertimeProd[t]
      + StoreCost * Inventory[t]
    )
  ), "\n",
  "RegularProd=", show(RegularProd), "\n",
  "OvertimeProd=", show(OvertimeProd), "\n",
  "Inventory=", show(Inventory), "\n"
];