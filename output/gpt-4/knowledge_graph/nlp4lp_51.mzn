include "globals.mzn";

% Parameters
int: W;
array[1..W] of int: Demand;
array[1..W] of int: RegularLabor;
array[1..W] of int: OvertimeLabor;
int: RegularCost;
int: OvertimeCost;
float: AssemblyTime;
int: MaterialCost;
int: SellingPrice;
int: HoldingCost;
int: SalvageValue;

% Variables
array[1..W] of var 0..max(RegularLabor): RegularLaborUsed;
array[1..W] of var 0..max(OvertimeLabor): OvertimeLaborUsed;
array[1..W] of var 0..sum(Demand): BasketsProduced;
array[1..W] of var 0..sum(Demand): BasketsSold;
array[1..W] of var 0..sum(Demand): BasketsHeld;

% Constraints
constraint forall(w in 1..W)(
  BasketsProduced[w] <= (RegularLaborUsed[w] + OvertimeLaborUsed[w]) / AssemblyTime
);

constraint forall(w in 1..W)(
  BasketsSold[w] = min(Demand[w], if w = 1 then BasketsProduced[w] else BasketsProduced[w] + BasketsHeld[w-1] endif)
);

constraint forall(w in 1..W)(
  BasketsHeld[w] = if w = 1 then BasketsProduced[w] - BasketsSold[w] else BasketsProduced[w] + BasketsHeld[w-1] - BasketsSold[w] endif
);

constraint forall(w in 1..W)(
  RegularLaborUsed[w] <= RegularLabor[w]
);

constraint forall(w in 1..W)(
  OvertimeLaborUsed[w] <= OvertimeLabor[w]
);

% Objective
var int: Revenue = sum(w in 1..W)(SellingPrice * BasketsSold[w]);
var int: Cost = sum(w in 1..W)(RegularCost * RegularLaborUsed[w] + OvertimeCost * OvertimeLaborUsed[w] + MaterialCost * BasketsProduced[w] + HoldingCost * BasketsHeld[w]);
var int: Salvage = SalvageValue * BasketsHeld[W];
var int: Profit = Revenue - Cost + Salvage;

solve maximize Profit;

% Output
output ["Profit: ", show(Profit), "\n",
        "Regular Labor Used: ", show(RegularLaborUsed), "\n",
        "Overtime Labor Used: ", show(OvertimeLaborUsed), "\n",
        "Baskets Produced: ", show(BasketsProduced), "\n",
        "Baskets Sold: ", show(BasketsSold), "\n",
        "Baskets Held: ", show(BasketsHeld), "\n"];