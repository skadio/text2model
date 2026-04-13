% Parameters
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

% Variables
array[1..W] of var float: reg_hours;
array[1..W] of var float: ot_hours;

array[1..W] of var float: prod;      % baskets produced in week w
array[1..W] of var float: inv_end;   % inventory at end of week w

var float: profit;

% Constraints
constraint forall(w in 1..W) (reg_hours[w] >= 0.0 /\ reg_hours[w] <= RegularLabor[w]);
constraint forall(w in 1..W) (ot_hours[w]  >= 0.0 /\ ot_hours[w]  <= OvertimeLabor[w]);

constraint forall(w in 1..W) (prod[w] >= 0.0);
constraint forall(w in 1..W) (inv_end[w] >= 0.0);

% Production capacity from labor hours
constraint forall(w in 1..W) (
  prod[w] = (reg_hours[w] + ot_hours[w]) / AssemblyTime
);

% Inventory balance with no initial inventory
constraint inv_end[1] = prod[1] - Demand[1];
constraint forall(w in 2..W) (
  inv_end[w] = inv_end[w-1] + prod[w] - Demand[w]
);

% Demand must be met (no backlogging) already ensured by inv_end >= 0

% Objective
constraint profit =
  sum(w in 1..W) (SellingPrice * Demand[w])                                 % revenue from meeting demand
  - sum(w in 1..W) (MaterialCost * prod[w])                                 % material cost of produced baskets
  - sum(w in 1..W) (RegularCost * reg_hours[w] + OvertimeCost * ot_hours[w])% labor cost
  - sum(w in 1..W-1) (HoldingCost * inv_end[w])                             % holding cost (no holding after last week)
  + SalvageValue * inv_end[W];                                              % salvage value at season end

solve maximize profit;