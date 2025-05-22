% Parameters
int: W;
int: RegularCost;
int: OvertimeCost;
float: AssemblyTime;
int: MaterialCost;
int: SellingPrice;
int: HoldingCost;
int: SalvageValue;
array[1..W] of int: Demand;
array[1..W] of int: RegularLabor;
array[1..W] of int: OvertimeLabor;

% Variables
array[1..W] of var 0..max(Demand): BasketsProduced;
array[1..W] of var 0..max(RegularLabor): RegularLaborUsed;
array[1..W] of var 0..max(OvertimeLabor): OvertimeLaborUsed;
array[1..W] of var 0..max(Demand): BasketsSold;
array[1..W] of var 0..max(Demand): BasketsHeld;

% Constraints
constraint forall(w in 1..W) (
  BasketsProduced[w] = (RegularLaborUsed[w] + OvertimeLaborUsed[w]) / AssemblyTime
);
constraint forall(w in 1..W) (
  RegularLaborUsed[w] <= RegularLabor[w]
);
constraint forall(w in 1..W) (
  OvertimeLaborUsed[w] <= OvertimeLabor[w]
);
constraint forall(w in 1..W) (
  BasketsSold[w] = if w == 1 then min(Demand[w], BasketsProduced[w]) else min(Demand[w], BasketsProduced[w] + BasketsHeld[w-1])
);
constraint forall(w in 1..W) (
  BasketsHeld[w] = if w == 1 then max(0, BasketsProduced[w] - Demand[w]) else if w < W then max(0, BasketsProduced[w] + BasketsHeld[w-1] - Demand[w]) else 0
);

% Objective
var int: TotalRevenue = sum(w in 1..W) (SellingPrice * BasketsSold[w]) + SalvageValue * BasketsHeld[W];
var int: TotalCost = sum(w in 1..W) (MaterialCost * BasketsProduced[w] + HoldingCost * (if w < W then BasketsHeld[w] else 0) + RegularCost * RegularLaborUsed[w] + OvertimeCost * OvertimeLaborUsed[w]);
var int: Profit = TotalRevenue - TotalCost;
solve maximize Profit;