int: W;
set of int: Weeks = 1..W;

float: RegularCost;
float: OvertimeCost;
float: AssemblyTime;
float: MaterialCost;
float: SellingPrice;
float: HoldingCost;
float: SalvageValue;

array[Weeks] of int: Demand;
array[Weeks] of float: RegularLabor;   % max regular hours available each week
array[Weeks] of float: OvertimeLabor;  % max overtime hours available each week

% Decision variables
array[Weeks] of var 0.0..RegularLabor[w]: RegHours;
array[Weeks] of var 0.0..OvertimeLabor[w]: OTHours;
array[Weeks] of var 0.0..infinity: Produce;     % baskets produced in week w (can be fractional if AssemblyTime not divisor)
array[0..W] of var 0.0..infinity: Inventory;    % end-of-week inventory, Inventory[0]=0
array[Weeks] of var 0.0..infinity: Sell;        % baskets sold in week w

constraint Inventory[0] = 0.0;

% Production capacity from labor
constraint
  forall(w in Weeks) (
    Produce[w] <= (RegHours[w] + OTHours[w]) / AssemblyTime
  );

% Flow balance and demand satisfaction
constraint
  forall(w in Weeks) (
    Inventory[w-1] + Produce[w] = Sell[w] + Inventory[w]
  );

constraint
  forall(w in Weeks) (
    Sell[w] = Demand[w]
  );

% Objective: maximize profit
var float: Profit =
    sum(w in Weeks)( SellingPrice * Sell[w] )
  - sum(w in Weeks)( MaterialCost * Produce[w] )
  - sum(w in Weeks)( RegularCost * RegHours[w] + OvertimeCost * OTHours[w] )
  - sum(w in 1..W-1)( HoldingCost * Inventory[w] )
  + SalvageValue * Inventory[W];

solve maximize Profit;

output [
  "Profit = ", show(Profit), "\n",
  "RegHours = ", show(RegHours), "\n",
  "OTHours = ", show(OTHours), "\n",
  "Produce = ", show(Produce), "\n",
  "Inventory = ", show(Inventory), "\n"
];