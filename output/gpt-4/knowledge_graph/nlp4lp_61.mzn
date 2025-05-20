include "globals.mzn";

% Parameters
int: T; % The number of time periods
array[1..T] of int: Demands; % Demand at time t
array[1..T] of int: UnloadCosts; % Unloading cost at time t
array[1..T] of int: UnloadCapacity; % Unloading capacity at time t
int: HoldingCost; % Cost for holding containers
int: MaxContainer; % Maximum number of containers that can be held
int: InitContainer; % Initial number of containers at the start
int: NumCranes; % Number of cranes available for unloading
int: CraneCapacity; % Capacity of each crane
int: CraneCost; % Cost for renting each crane

% Variables
array[1..T] of var 0..MaxContainer: Containers; % Number of containers at time t
array[1..T] of var 0..UnloadCapacity: Unload; % Number of containers unloaded at time t
array[1..T] of var 0..NumCranes: Cranes; % Number of cranes rented at time t

% Constraints
constraint Containers[1] = InitContainer + Unload[1] - Demands[1];
constraint forall(t in 2..T) (
    Containers[t] = Containers[t-1] + Unload[t] - Demands[t]
);
constraint forall(t in 1..T) (
    Unload[t] <= UnloadCapacity[t]
);
constraint forall(t in 1..T) (
    Cranes[t] * CraneCapacity >= Demands[t]
);
constraint Containers[T] = 0;

% Objective
var int: TotalCost = sum(t in 1..T) (UnloadCosts[t] * Unload[t] + HoldingCost * Containers[t] + CraneCost * Cranes[t]);
solve minimize TotalCost;

% Output
output ["Total cost: ", show(TotalCost), "\n"] ++
["Containers: ", show(Containers), "\n"] ++
["Unload: ", show(Unload), "\n"] ++
["Cranes: ", show(Cranes), "\n"];