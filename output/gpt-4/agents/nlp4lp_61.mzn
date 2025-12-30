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
array[1..T] of var 0..UnloadCapacity[t]: Unloaded; % Number of containers unloaded at each month
array[1..T] of var 0..NumCranes: Cranes; % Number of cranes rented at each month

% Constraints

% The number of containers in the yard at the end of each month should be less than or equal to the maximum number of containers that can be held
constraint forall(t in 1..T)(Containers[t] <= MaxContainer);

% The number of containers unloaded at each month should be less than or equal to the unloading capacity at that month
constraint forall(t in 1..T)(Unloaded[t] <= UnloadCapacity[t]);

% The number of cranes rented at each month should be less than or equal to the number of cranes available for unloading
constraint forall(t in 1..T)(Cranes[t] <= NumCranes);

% The number of containers in the yard at the end of each month should be equal to the number of containers unloaded at that month plus the number of containers in the yard at the end of the previous month minus the demand at that month
constraint Containers[1] = InitContainer + Unloaded[1] - Demands[1];
constraint forall(t in 2..T)(Containers[t] = Containers[t-1] + Unloaded[t] - Demands[t]);

% The number of containers in the yard at the end of the last month should be zero
constraint Containers[T] = 0;

% The number of containers unloaded at each month should be less than or equal to the number of cranes rented at that month times the capacity of each crane
constraint forall(t in 1..T)(Unloaded[t] <= Cranes[t] * CraneCapacity);

% Objective
solve minimize sum(t in 1..T)(UnloadCosts[t]*Unloaded[t] + HoldingCost*Containers[t] + CraneCost*Cranes[t]);