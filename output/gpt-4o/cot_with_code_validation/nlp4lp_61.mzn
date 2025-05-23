% Parameters
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

% Largest unloading capacity (used for uniform variable bounds)
int: MaxUnload = max(t in 1..T)(UnloadCapacity[t]);

% Variables
array[1..T] of var 0..MaxUnload: Unload;            % containers unloaded in month t
array[1..T] of var 0..MaxContainer: StartInv;        % inventory at start of month t
array[1..T] of var 0..MaxContainer: EndInv;          % inventory at end of month t
array[1..T] of var 0..NumCranes: RentCranes;         % cranes rented in month t

% Constraints
% 1. Inventory linkage
constraint StartInv[1] = InitContainer;
constraint forall(t in 2..T)(
  StartInv[t] = EndInv[t-1]
);

% 2. Flow balance
constraint forall(t in 1..T)(
  StartInv[t] + Unload[t] = Demands[t] + EndInv[t]
);

% 3. Unloading capacity limits
constraint forall(t in 1..T)(
  Unload[t] <= UnloadCapacity[t]
);

% 4. Yard capacity limits
constraint forall(t in 1..T)(
  EndInv[t] <= MaxContainer
);

% 5. Crane loading capacity
constraint forall(t in 1..T)(
  Demands[t] <= RentCranes[t] * CraneCapacity
);

% 6. No inventory after the last month
constraint EndInv[T] = 0;

% Objective
var int: TotalCost =
  sum(t in 1..T)(
        Unload[t]    * UnloadCosts[t]
      + EndInv[t]    * HoldingCost
      + RentCranes[t]* CraneCost
  );

solve minimize TotalCost;