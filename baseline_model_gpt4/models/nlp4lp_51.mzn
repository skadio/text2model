include "globals.mzn";

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
  BasketsProduced[w] * AssemblyTime <= RegularLaborUsed[w] + OvertimeLaborUsed[w]
);

constraint forall(w in 1..W)(
  RegularLaborUsed[w] <= RegularLabor[w]
);

constraint forall(w in 1..W)(
  OvertimeLaborUsed[w] <= OvertimeLabor[w]
);

constraint forall(w in 1..W)(
  BasketsSold[w] <= Demand[w]
);

constraint forall(w in 1..W)(
  if w = 1 then
    BasketsHeld[w] = BasketsProduced[w] - BasketsSold[w]
  else
    BasketsHeld[w] = BasketsHeld[w-1] + BasketsProduced[w] - BasketsSold[w]
  endif
);

% Objective
var int: Profit = sum(w in 1..W)(
  SellingPrice * BasketsSold[w] - MaterialCost * BasketsProduced[w] - RegularCost * RegularLaborUsed[w] - OvertimeCost * OvertimeLaborUsed[w] - HoldingCost * BasketsHeld[w]
) + SalvageValue * BasketsHeld[W];

solve maximize Profit;

% Output
output ["Profit: ", show(Profit), "\n"];
output ["Baskets Produced: ", show(BasketsProduced), "\n"];
output ["Baskets Sold: ", show(BasketsSold), "\n"];
output ["Baskets Held: ", show(BasketsHeld), "\n"];
output ["Regular Labor Used: ", show(RegularLaborUsed), "\n"];
output ["Overtime Labor Used: ", show(OvertimeLaborUsed), "\n"];