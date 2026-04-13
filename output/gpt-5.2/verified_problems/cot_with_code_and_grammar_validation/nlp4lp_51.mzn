int: W;

float: RegularCost;
float: OvertimeCost;
float: AssemblyTime;
float: MaterialCost;
float: SellingPrice;
float: HoldingCost;
float: SalvageValue;

array[1..W] of int: Demand;
array[1..W] of float: RegularLabor;
array[1..W] of float: OvertimeLabor;

int: UBDemand = sum(w in 1..W)(Demand[w]);

array[1..W] of var float: RegHours;
array[1..W] of var float: OTHours;

array[1..W] of var 0..UBDemand: Produce;
array[1..W] of var 0..UBDemand: Inventory;
array[1..W] of var 0..UBDemand: Sell;

var float: Profit;

constraint forall(w in 1..W) (RegHours[w] >= 0.0 /\ RegHours[w] <= RegularLabor[w]);
constraint forall(w in 1..W) (OTHours[w] >= 0.0 /\ OTHours[w] <= OvertimeLabor[w]);

constraint forall(w in 1..W) (
  int2float(Produce[w]) * AssemblyTime <= RegHours[w] + OTHours[w]
);

constraint forall(w in 1..W) (Sell[w] = Demand[w]);

constraint Inventory[1] = Produce[1] - Sell[1];
constraint forall(w in 2..W) (
  Inventory[w] = Inventory[w-1] + Produce[w] - Sell[w]
);

constraint Sell[1] <= Produce[1];
constraint forall(w in 2..W) (
  Sell[w] <= Inventory[w-1] + Produce[w]
);

constraint Profit =
  sum(w in 1..W)(SellingPrice * int2float(Sell[w]))
  + SalvageValue * int2float(Inventory[W])
  - sum(w in 1..W)(MaterialCost * int2float(Produce[w]))
  - sum(w in 1..W)(RegularCost * RegHours[w] + OvertimeCost * OTHours[w])
  - sum(w in 1..W-1)(HoldingCost * int2float(Inventory[w]));

solve maximize Profit;