% Production planning with regular + overtime and inventory carryover

% Parameters
int: N;
array[1..N] of float: Demand;
float: MaxRegularAmount;
float: CostRegular;
float: CostOvertime;
float: StoreCost;

% Variables
array[1..N] of var 0.0..infinity: RegularProd;
array[1..N] of var 0.0..infinity: OvertimeProd;
array[1..N] of var 0.0..infinity: Inventory;

% Regular production capacity
constraint forall(t in 1..N) (
  RegularProd[t] <= MaxRegularAmount
);

% Inventory balance (no backlogging; Inventory is constrained nonnegative)
constraint Inventory[1] = RegularProd[1] + OvertimeProd[1] - Demand[1];
constraint forall(t in 2..N) (
  Inventory[t] = Inventory[t-1] + RegularProd[t] + OvertimeProd[t] - Demand[t]
);

% Objective: minimize total cost
var float: TotalCost =
  sum(t in 1..N) (
    CostRegular * RegularProd[t]
  + CostOvertime * OvertimeProd[t]
  + StoreCost * Inventory[t]
  );

solve minimize TotalCost;