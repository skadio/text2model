int: T;
set of int: TIME = 1..T;

array[TIME] of int: Demands;
array[TIME] of int: UnloadCosts;
array[TIME] of int: UnloadCapacity;

int: HoldingCost;
int: MaxContainer;
int: InitContainer;

int: NumCranes;
int: CraneCapacity;
int: CraneCost;

array[TIME] of var 0..max(UnloadCapacity): Unload;
array[TIME] of var 0..NumCranes: CranesRented;
array[0..T] of var 0..MaxContainer: Inventory;

constraint Inventory[0] = InitContainer;
constraint Inventory[T] = 0;

constraint forall(t in TIME) (
  Unload[t] <= UnloadCapacity[t]
);

constraint forall(t in TIME) (
  Demands[t] <= CranesRented[t] * CraneCapacity
);

constraint forall(t in TIME) (
  Inventory[t] = Inventory[t-1] + Unload[t] - Demands[t]
);

constraint forall(t in TIME) (
  Inventory[t] >= 0
);

var int: TotalCost =
  sum(t in TIME) (Unload[t] * UnloadCosts[t]) +
  sum(t in TIME) (Inventory[t] * HoldingCost) +
  sum(t in TIME) (CranesRented[t] * CraneCost);

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "Unload = ", show(Unload), "\n",
  "CranesRented = ", show(CranesRented), "\n",
  "Inventory = ", show(Inventory), "\n"
];