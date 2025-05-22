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
array[1..T] of var 0..MaxContainer: Unloads; % Containers unloaded at each month
array[1..T] of var 0..NumCranes: Cranes; % Cranes rented at each month

% Constraints
% Initial condition
constraint Containers[1] = InitContainer + Unloads[1] - Demands[1];

% Containers transition
constraint forall(t in 2..T) (
    Containers[t] = Containers[t-1] + Unloads[t] - Demands[t]
);

% Unloading capacity
constraint forall(t in 1..T) (
    Unloads[t] <= UnloadCapacity[t]
);

% Crane capacity
constraint forall(t in 1..T) (
    Cranes[t]*CraneCapacity >= Demands[t]
);

% Final condition
constraint Containers[T] = 0;

% Objective
var int: TotalCost = sum(t in 1..T) (UnloadCosts[t]*Unloads[t] + HoldingCost*Containers[t] + CraneCost*Cranes[t]);
solve minimize TotalCost;