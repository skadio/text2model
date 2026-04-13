int: N;
set of int: P = 1..N;

array[P] of float: Demand;

float: MaxRegularAmount;
float: CostRegular;
float: CostOvertime;
float: StoreCost;

array[P] of var float: RegularProd;
array[P] of var float: OvertimeProd;
array[P] of var float: Inventory;

constraint forall(p in P) (
  RegularProd[p] >= 0.0 /\ RegularProd[p] <= MaxRegularAmount /\
  OvertimeProd[p] >= 0.0 /\
  Inventory[p] >= 0.0
);

constraint
  RegularProd[1] + OvertimeProd[1] - Inventory[1] = Demand[1];

constraint forall(p in 2..N) (
  Inventory[p-1] + RegularProd[p] + OvertimeProd[p] - Inventory[p] = Demand[p]
);

var float: TotalCost =
  sum(p in P)(
    CostRegular * RegularProd[p] +
    CostOvertime * OvertimeProd[p] +
    StoreCost * Inventory[p]
  );

solve minimize TotalCost;

output [
  "TotalCost=", show(TotalCost), "\n",
  "RegularProd=", show(RegularProd), "\n",
  "OvertimeProd=", show(OvertimeProd), "\n",
  "Inventory=", show(Inventory), "\n"
];