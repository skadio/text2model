include "globals.mzn";

% Parameters (provided via the .dzn file)
int: N;
array[1..N] of int: Demand;
int: MaxRegularAmount;
int: CostRegular;
int: CostOvertime;
int: StoreCost;

% Compute an upper bound for overtime and inventory as the sum of demands.
int: sumDemand = sum(i in 1..N)(Demand[i]);

% Decision variables
array[1..N] of var 0..MaxRegularAmount: Regular;
array[1..N] of var 0..sumDemand: Overtime;
array[1..N] of var 0..sumDemand: Inventory;

% Inventory balance constraints:
constraint Inventory[1] = Regular[1] + Overtime[1] - Demand[1];
constraint Inventory[1] >= 0;
constraint forall(i in 2..N) (
    Inventory[i] = Inventory[i-1] + Regular[i] + Overtime[i] - Demand[i] /\ Inventory[i] >= 0
);

% Ensure no leftover inventory after the final month
constraint Inventory[N] = 0;

% Objective: minimize total cost (production cost + overtime cost + storage cost)
% Note: Storage costs are applied on end-of-month inventory for months 1..N-1.
var int: TotalCost = 
      sum(i in 1..N)(CostRegular * Regular[i] + CostOvertime * Overtime[i])
    + sum(i in 1..N-1)(StoreCost * Inventory[i]);

solve minimize TotalCost;

output [
  "Regular production: ", show(Regular), "\n",
  "Overtime production: ", show(Overtime), "\n",
  "Inventory levels: ", show(Inventory), "\n",
  "Total Cost: ", show(TotalCost), "\n"
];