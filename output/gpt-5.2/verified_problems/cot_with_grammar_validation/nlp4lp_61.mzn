% Parameters
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

% Variables
array[TIME] of var 0..max(UnloadCapacity): Unloaded;
array[TIME] of var 0..MaxContainer: InventoryEnd;
array[TIME] of var 0..NumCranes: CranesRented;

var int: TotalCost;

% Constraints
constraint
  InventoryEnd[T] = 0;

constraint
  forall(t in TIME) (
    Unloaded[t] <= UnloadCapacity[t]
  );

constraint
  forall(t in TIME) (
    Demands[t] <= CranesRented[t] * CraneCapacity
  );

constraint
  forall(t in TIME) (
    Unloaded[t] + (if t = 1 then InitContainer else InventoryEnd[t-1] endif) >= Demands[t]
  );

constraint
  forall(t in TIME) (
    InventoryEnd[t] = Unloaded[t] + (if t = 1 then InitContainer else InventoryEnd[t-1] endif) - Demands[t]
  );

% Objective
constraint
  TotalCost =
    sum(t in TIME) (UnloadCosts[t] * Unloaded[t])
  + sum(t in 1..T-1) (HoldingCost * InventoryEnd[t])
  + sum(t in TIME) (CraneCost * CranesRented[t]);

solve minimize TotalCost;