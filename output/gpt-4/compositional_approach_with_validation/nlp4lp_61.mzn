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
array[1..T] of var 0..MaxContainer: Containers; % Number of containers in the yard at the end of each month
array[1..T] of var 0..UnloadCapacity[t]: Unloaded; % Number of containers unloaded at time t
array[1..T] of var 0..NumCranes: Cranes; % Number of cranes rented at time t

% Constraints

% The number of containers in the yard at the end of each month should not exceed the maximum capacity
constraint forall(t in 1..T) (
  Containers[t] <= MaxContainer
);

% The number of containers unloaded at each time period should not exceed the unloading capacity
constraint forall(t in 1..T) (
  Unloaded[t] <= UnloadCapacity[t]
);

% The number of cranes rented at each time period should not exceed the number of cranes available
constraint forall(t in 1..T) (
  Cranes[t] <= NumCranes
);

% The number of containers in the yard at the end of each month is equal to the number of containers at the start of the month plus the number of containers unloaded minus the demand
constraint Containers[1] = InitContainer + Unloaded[1] - Demands[1];
constraint forall(t in 2..T) (
  Containers[t] = Containers[t-1] + Unloaded[t] - Demands[t]
);

% The number of containers loaded onto ships at each time period should not exceed the capacity of the cranes rented
constraint forall(t in 1..T) (
  Demands[t] <= Cranes[t] * CraneCapacity
);

% The yard should not contain any containers after the end of the last month
constraint Containers[T] = 0;

% Objective
solve minimize sum(t in 1..T) (UnloadCosts[t]*Unloaded[t] + HoldingCost*Containers[t] + CraneCost*Cranes[t]);