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

% Variables
array[1..T] of var 0..MaxContainer: Containers; % Containers in the yard at the end of each month
array[1..T] of var 0..MaxContainer: Unload; % Number of containers unloaded each month
array[1..T] of var 0..NumCranes: Cranes; % Number of cranes rented each month

% Constraints
% Initial condition
constraint Containers[1] = InitContainer + Unload[1] - Demands[1];

% Constraints for each month
constraint forall(t in 2..T) (
  Containers[t] = Containers[t-1] + Unload[t] - Demands[t]
);

% Unloading capacity constraint
constraint forall(t in 1..T) (
  Unload[t] <= UnloadCapacity[t]
);

% Crane capacity constraint
constraint forall(t in 1..T) (
  Cranes[t]*CraneCapacity >= Demands[t]
);

% Constraints for the last month
constraint Containers[T] = 0;

% Objective
var int: TotalCost = sum(t in 1..T) (Unload[t]*UnloadCosts[t] + Containers[t]*HoldingCost + Cranes[t]*CraneCost);
solve minimize TotalCost;