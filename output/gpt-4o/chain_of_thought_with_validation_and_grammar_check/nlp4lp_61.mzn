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

int: MaxUnloadCapacity = max(UnloadCapacity);

% Variables
array[TIME] of var 0..MaxUnloadCapacity: Unloaded;    % Containers unloaded in period t
array[TIME] of var 0..NumCranes: Cranes;              % Cranes rented in period t
array[TIME] of var 0..MaxContainer: Inventory;        % Yard stock at end of period t

% Constraints
constraint
    forall(t in TIME)(
        Unloaded[t] <= UnloadCapacity[t]              % Unloading capacity per period
    );

constraint
    forall(t in TIME)(
        Demands[t] <= Cranes[t] * CraneCapacity       % Crane capacity must cover demand
    );

constraint
    Inventory[1] = InitContainer + Unloaded[1] - Demands[1];   % Balance in first period;

constraint
    forall(t in 2..T)(
        Inventory[t] = Inventory[t-1] + Unloaded[t] - Demands[t] % Balance in subsequent periods
    );

constraint
    Inventory[T] = 0;                                 % No containers left after last period

% Objective
solve minimize
    sum(t in TIME)(
          Unloaded[t] * UnloadCosts[t]
        + Inventory[t] * HoldingCost
        + Cranes[t]   * CraneCost
    );