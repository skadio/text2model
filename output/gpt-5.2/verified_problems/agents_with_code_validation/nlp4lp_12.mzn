% Parameters
int: T;                                % Total number of periods (months)
set of int: PERIODS = 1..T;

array[PERIODS] of int: Deliver;        % Demand delivered at end of each period
int: StorageCost;                      % Holding cost per unit per period
int: SwitchCost;                       % Cost per unit change in production between periods

% Helpful bounds (prevents huge default domains that can cause timeouts)
int: total_demand = sum(i in PERIODS)(Deliver[i]);
int: max_demand   = max(i in PERIODS)(Deliver[i]);

% Variables (bounded for tractability)
array[PERIODS] of var 0..total_demand: Produce;
array[PERIODS] of var 0..total_demand: Inventory;

array[2..T] of var 0..total_demand: AbsChange;

var 0..(StorageCost * total_demand * max(0, T-1)): TotalHoldingCost;
var 0..(SwitchCost * total_demand * max(0, T-1)): TotalSwitchCost;
var 0..(StorageCost * total_demand * max(0, T-1) + SwitchCost * total_demand * max(0, T-1)): TotalCost;

% Constraints

% Inventory balance with zero initial inventory:
constraint Inventory[1] = Produce[1] - Deliver[1];
constraint forall(t in 2..T) (
  Inventory[t] = Inventory[t-1] + Produce[t] - Deliver[t]
);

% No backlog
constraint forall(t in PERIODS) (Inventory[t] >= 0);

% End-of-horizon inventory has no value; enforce zero to avoid unnecessary production
constraint Inventory[T] = 0;

% Absolute production change: AbsChange[t] = |Produce[t] - Produce[t-1]|
constraint forall(t in 2..T) (
  AbsChange[t] >= Produce[t] - Produce[t-1] /\
  AbsChange[t] >= Produce[t-1] - Produce[t]
);

% Costs (no holding cost for end-of-year inventory)
constraint TotalHoldingCost = StorageCost * sum(t in 1..T-1)(Inventory[t]);
constraint TotalSwitchCost  = SwitchCost  * sum(t in 2..T)(AbsChange[t]);
constraint TotalCost = TotalHoldingCost + TotalSwitchCost;

solve minimize TotalCost;