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
array[1..W] of var 0..max(Demand): BasketsSold;
array[1..W] of var 0..max(Demand): BasketsHeld;
array[1..W] of var 0..RegularLabor[W]: RegularLaborUsed;
array[1..W] of var 0..OvertimeLabor[W]: OvertimeLaborUsed;

% Constraints
constraint forall(w in 1..W)(
  BasketsProduced[w] = floor(RegularLaborUsed[w] / AssemblyTime) + floor(OvertimeLaborUsed[w] / AssemblyTime)
);
constraint forall(w in 1..W)(
  BasketsSold[w] = min(Demand[w], BasketsProduced[w] + if w > 1 then BasketsHeld[w-1] else 0 endif)
);
constraint forall(w in 1..W)(
  BasketsHeld[w] = BasketsProduced[w] + if w > 1 then BasketsHeld[w-1] else 0 endif - BasketsSold[w]
);
constraint forall(w in 1..W)(
  RegularLaborUsed[w] <= RegularLabor[w]
);
constraint forall(w in 1..W)(
  OvertimeLaborUsed[w] <= OvertimeLabor[w]
);

% Objective
var int: TotalRevenue = sum(w in 1..W)(BasketsSold[w] * SellingPrice);
var int: TotalCost = sum(w in 1..W)(RegularLaborUsed[w] * RegularCost + OvertimeLaborUsed[w] * OvertimeCost + BasketsProduced[w] * MaterialCost + BasketsHeld[w] * HoldingCost);
var int: SalvageRevenue = BasketsHeld[W] * SalvageValue;
var int: Profit = TotalRevenue - TotalCost + SalvageRevenue;

solve maximize Profit;