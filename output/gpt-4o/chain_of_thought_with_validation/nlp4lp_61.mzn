% Parameters
int: T;
set of int: Time = 1..T;

array[Time] of int: Demands;
array[Time] of int: UnloadCosts;
array[Time] of int: UnloadCapacity;

int: HoldingCost;
int: MaxContainer;
int: InitContainer;

int: NumCranes;
int: CraneCapacity;
int: CraneCost;

% Derived parameter
int: MaxUnloadCap = max(UnloadCapacity);

% Variables
array[Time] of var 0..MaxUnloadCap: Unload;             % containers unloaded
array[Time] of var 0..MaxContainer: EndInv;             % end-of-month inventory
array[Time] of var 0..NumCranes: CranesRented;          % cranes rented

% Constraints
% 1. Unloading capacity
constraint
  forall(t in Time) (
    Unload[t] <= UnloadCapacity[t]
  );

% 2. Inventory balance
constraint
  EndInv[1] = InitContainer + Unload[1] - Demands[1];

constraint
  forall(t in 2..T) (
    EndInv[t] = EndInv[t-1] + Unload[t] - Demands[t]
  );

% 3. Yard capacity and final empty yard
constraint EndInv[T] = 0;

% 4. Crane capacity to meet demand
constraint
  forall(t in Time) (
    CranesRented[t] * CraneCapacity >= Demands[t]
  );

% Objective
var int: TotalCost =
    sum(t in Time)(Unload[t]   * UnloadCosts[t]) +
    sum(t in Time)(EndInv[t]   * HoldingCost)   +
    sum(t in Time)(CranesRented[t] * CraneCost);

solve minimize TotalCost;