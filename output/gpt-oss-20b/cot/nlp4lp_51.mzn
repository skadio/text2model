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
array[1..W] of var int: x;
array[1..W] of var float: r;
array[1..W] of var float: o;
array[0..W] of var int: inventory;

% Constraints
constraint inventory[0] = 0;
constraint forall(w in 1..W)(
    inventory[w] = inventory[w-1] + x[w] - Demand[w]
);
constraint forall(w in 1..W)(
    inventory[w] >= 0
);
constraint forall(w in 1..W)(
    r[w] + o[w] = x[w] * AssemblyTime
);
constraint forall(w in 1..W)(
    r[w] <= RegularLabor[w]
);
constraint forall(w in 1..W)(
    o[w] <= OvertimeLabor[w]
);
constraint forall(w in 1..W)(
    r[w] >= 0
);
constraint forall(w in 1..W)(
    o[w] >= 0
);
constraint forall(w in 1..W)(
    x[w] >= 0
);

% Objective
var float: profit = sum(w in 1..W)(SellingPrice * Demand[w]) 
                    - sum(w in 1..W)(RegularCost * r[w] + OvertimeCost * o[w] + MaterialCost * x[w])
                    - sum(w in 1..W-1)(HoldingCost * inventory[w])
                    + SalvageValue * inventory[W];

solve maximize profit;