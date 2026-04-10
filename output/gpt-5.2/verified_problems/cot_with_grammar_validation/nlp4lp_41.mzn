int: N;
array[1..N] of float: Demand;

float: MaxRegularAmount;
float: CostRegular;
float: CostOvertime;
float: StoreCost;

array[1..N] of var float: RegularProd;
array[1..N] of var float: OvertimeProd;
array[0..N] of var float: Inventory;

var float: TotalCost;

constraint Inventory[0] = 0.0;

constraint forall(t in 1..N) (
  Inventory[t] = Inventory[t-1] + RegularProd[t] + OvertimeProd[t] - Demand[t]
);

constraint forall(t in 1..N) (RegularProd[t] >= 0.0);
constraint forall(t in 1..N) (OvertimeProd[t] >= 0.0);
constraint forall(t in 0..N) (Inventory[t] >= 0.0);

constraint forall(t in 1..N) (RegularProd[t] <= MaxRegularAmount);

constraint TotalCost =
  sum(t in 1..N)(CostRegular * RegularProd[t] + CostOvertime * OvertimeProd[t]) +
  sum(t in 1..N)(StoreCost * Inventory[t]);

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "RegularProd = ", show(RegularProd), "\n",
  "OvertimeProd = ", show(OvertimeProd), "\n",
  "Inventory = ", show(Inventory), "\n"
];