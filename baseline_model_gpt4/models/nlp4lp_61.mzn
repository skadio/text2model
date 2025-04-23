include "globals.mzn";

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

% Decision Variables
array[1..T] of var 0..MaxContainer: Containers; % Number of containers in the yard at the end of each month
array[1..T] of var 0..UnloadCapacity: Unload; % Number of containers to unload each month
array[1..T] of var 0..NumCranes: Cranes; % Number of cranes to rent each month

% Constraints
constraint Containers[1] = InitContainer + Unload[1] - Demands[1];
constraint forall(t in 2..T) (
    Containers[t] = Containers[t-1] + Unload[t] - Demands[t]
);
constraint forall(t in 1..T) (
    Unload[t] <= UnloadCapacity[t]
);
constraint forall(t in 1..T) (
    Cranes[t]*CraneCapacity >= Demands[t]
);
constraint Containers[T] = 0;

% Objective Function
var int: TotalCost = sum(t in 1..T) (UnloadCosts[t]*Unload[t] + HoldingCost*Containers[t] + CraneCost*Cranes[t]);
solve minimize TotalCost;

% Output
output ["Total Cost: ", show(TotalCost), "\n"] ++
["Containers: "] ++ [show(Containers[t]) ++ " " | t in 1..T] ++ ["\n"] ++
["Unload: "] ++ [show(Unload[t]) ++ " " | t in 1..T] ++ ["\n"] ++
["Cranes: "] ++ [show(Cranes[t]) ++ " " | t in 1..T] ++ ["\n"];