% Seaport container unloading / storage / crane rental planning

% --------------------
% Parameters (to be provided in .dzn)
% --------------------
int: T;
array[1..T] of int: Demands;
array[1..T] of int: UnloadCosts;
array[1..T] of int: UnloadCapacity;
int: HoldingCost;
int: MaxContainer;
int: InitContainer;
int: NumCranes;
int: CraneCapacity;
int: CraneCost;

% --------------------
% Decision variables
% --------------------
array[1..T] of var 0..max(UnloadCapacity): Unloaded;
array[1..T] of var 0..MaxContainer: InventoryEnd;
array[1..T] of var 0..NumCranes: CranesRented;

var int: TotalCost;

% --------------------
% Constraints
% --------------------
constraint forall(t in 1..T) (
  Unloaded[t] <= UnloadCapacity[t]
);

constraint forall(t in 1..T) (
  Unloaded[t] <= CranesRented[t] * CraneCapacity
);

% Inventory balance
constraint InventoryEnd[1] = InitContainer + Unloaded[1] - Demands[1];
constraint forall(t in 2..T) (
  InventoryEnd[t] = InventoryEnd[t-1] + Unloaded[t] - Demands[t]
);

% No inventory after last month
constraint InventoryEnd[T] = 0;

% --------------------
% Objective
% --------------------
constraint TotalCost =
    sum(t in 1..T) (UnloadCosts[t] * Unloaded[t])
  + sum(t in 1..T-1) (HoldingCost * InventoryEnd[t])
  + sum(t in 1..T) (CraneCost * CranesRented[t]);

solve minimize TotalCost;