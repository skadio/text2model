% Production and inventory planning with switching costs

% Parameters
int: T;
array[1..T] of int: Deliver;
int: StorageCost;
int: SwitchCost;

% Variables
array[1..T] of var 0..int_max: Produce;
array[0..T] of var 0..int_max: Inv;
array[2..T] of var 0..int_max: Diff;

var int: TotalStorageCost;
var int: TotalSwitchCost;
var int: TotalCost;

% Constraints
constraint Inv[0] = 0;
constraint Inv[T] = 0;

constraint forall(t in 1..T) (
  Inv[t] = Inv[t-1] + Produce[t] - Deliver[t]
);

% Absolute differences for switching cost
constraint forall(t in 2..T) (
  Diff[t] >= Produce[t] - Produce[t-1]
);
constraint forall(t in 2..T) (
  Diff[t] >= Produce[t-1] - Produce[t]
);

% Costs (no storage cost on end-of-year inventory; Inv[T]=0 anyway)
constraint TotalStorageCost = StorageCost * sum(t in 1..T-1)(Inv[t]);
constraint TotalSwitchCost  = SwitchCost  * sum(t in 2..T)(Diff[t]);
constraint TotalCost = TotalStorageCost + TotalSwitchCost;

% Objective
solve minimize TotalCost;

% Optional output
output [
  "Produce = ", show(Produce), "\n",
  "Inv     = ", show([Inv[t] | t in 0..T]), "\n",
  "TotalStorageCost = ", show(TotalStorageCost), "\n",
  "TotalSwitchCost  = ", show(TotalSwitchCost), "\n",
  "TotalCost        = ", show(TotalCost), "\n"
];