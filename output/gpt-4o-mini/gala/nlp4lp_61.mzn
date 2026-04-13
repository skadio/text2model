include "globals.mzn";

int: T;  % Number of time periods
array[1..T] of int: Demands;  % Demand at time t
array[1..T] of int: UnloadCosts;  % Unloading cost at time t
array[1..T] of int: UnloadCapacity;  % Unloading capacity at time t
int: HoldingCost;  % Cost for holding containers
int: MaxContainer;  % Maximum number of containers that can be held
int: InitContainer;  % Initial number of containers at the start
int: NumCranes;  % Number of cranes available for unloading
int: CraneCapacity;  % Capacity of each crane
int: CraneCost;  % Cost for renting each crane

/* Variables */
array[1..T] of var 0..MaxContainer: containers;  % Containers in the yard at the end of each month
array[1..T] of var 0..UnloadCapacity: unload;  % Containers unloaded at time t
array[1..T] of var 0..NumCranes: cranes;  % Cranes rented at time t

/* Constraints */
constraint count(containers, 0, 0);  % No containers should be left in the yard after the last month

% Cumulative constraint for unloading containers with crane capacity
array[1..T] of int: use = [CraneCapacity | t in 1..T];  % Resource usage for cranes
constraint cumulative(cranes, unload, use, NumCranes);

/* Objective function: Minimize total costs */
var int: totalCost = sum(t in 1..T)(UnloadCosts[t] * unload[t]) + 
                     sum(t in 1..T)(HoldingCost * containers[t]) + 
                     sum(t in 1..T)(CraneCost * cranes[t]);

solve minimize totalCost;

/* Output */
output [ "Total Cost = ", show(totalCost), "\nContainers in Yard = ", show(containers), 
         "\nUnloaded Containers = ", show(unload), "\nCranes Rented = ", show(cranes), "\n" ];