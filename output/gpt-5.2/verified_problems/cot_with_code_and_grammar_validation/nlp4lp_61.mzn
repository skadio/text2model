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
array[TIME] of var int: Unloaded;        % containers unloaded from rail cars in month t
array[TIME] of var int: EndInventory;    % containers in yard at end of month t
array[TIME] of var int: CranesRented;    % cranes rented in month t

var int: TotalCost;

% Constraints
constraint forall(t in TIME) (Unloaded[t] >= 0);
constraint forall(t in TIME) (CranesRented[t] >= 0);
constraint forall(t in TIME) (EndInventory[t] >= 0);

constraint forall(t in TIME) (Unloaded[t] <= UnloadCapacity[t]);
constraint forall(t in TIME) (CranesRented[t] <= NumCranes);
constraint forall(t in TIME) (EndInventory[t] <= MaxContainer);

% Inventory balance: start inventory + unloaded - shipped(demand) = end inventory
constraint EndInventory[1] = InitContainer + Unloaded[1] - Demands[1];
constraint forall(t in 2..T) (
  EndInventory[t] = EndInventory[t-1] + Unloaded[t] - Demands[t]
);

% Must end with zero containers after last month
constraint EndInventory[T] = 0;

% Crane capacity must cover monthly demand (loaded onto ships)
constraint forall(t in TIME) (
  CranesRented[t] * CraneCapacity >= Demands[t]
);

% Objective
constraint TotalCost =
    sum(t in TIME)(UnloadCosts[t] * Unloaded[t])
  + sum(t in TIME)(CraneCost * CranesRented[t])
  + sum(t in 1..T-1)(HoldingCost * EndInventory[t]);

solve minimize TotalCost;