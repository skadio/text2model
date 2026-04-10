int: T;
array[1..T] of int: Deliver;
int: StorageCost;
int: SwitchCost;

array[1..T] of var int: Produce;
array[0..T] of var int: Inv;

constraint Inv[0] = 0;
constraint Inv[T] = 0;

constraint forall(i in 1..T) (
  Inv[i] = Inv[i-1] + Produce[i] - Deliver[i]
);

constraint forall(i in 0..T) (
  Inv[i] >= 0
);

var int: TotalStorageCost =
  sum(i in 1..T-1) (StorageCost * Inv[i]);

var int: TotalSwitchCost =
  sum(i in 1..T-1) (SwitchCost * abs(Produce[i+1] - Produce[i]));

solve minimize TotalStorageCost + TotalSwitchCost;

output [
  "Produce = ", show(Produce), "\n",
  "Inv = ", show(Inv), "\n",
  "TotalStorageCost = ", show(TotalStorageCost), "\n",
  "TotalSwitchCost = ", show(TotalSwitchCost), "\n",
  "TotalCost = ", show(TotalStorageCost + TotalSwitchCost), "\n"
];