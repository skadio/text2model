include "globals.mzn";

% Parameters
int: CustomerCount;
int: VehicleCount;
array[1..CustomerCount] of int: CustomerDemand;
array[1..CustomerCount] of int: CustomerLBTW;
array[1..CustomerCount] of int: CustomerUBTW;
array[1..CustomerCount, 1..CustomerCount] of int: CustomerDistance;
array[1..CustomerCount] of int: CustomerServiceTime;
array[1..VehicleCount] of int: VehicleCapacity;

% Variables
array[1..VehicleCount, 1..CustomerCount] of var 0..1: x; % x[i,j] = 1 if vehicle i serves customer j
array[1..VehicleCount, 1..CustomerCount] of var int: arrival_time; % arrival time at each customer

% Constraints
constraint forall(i in 1..VehicleCount)(sum(j in 1..CustomerCount)(x[i,j]*CustomerDemand[j]) <= VehicleCapacity[i]); % vehicle capacity constraint
constraint forall(j in 1..CustomerCount)(sum(i in 1..VehicleCount)(x[i,j]) = 1); % each customer is served by exactly one vehicle
constraint forall(i in 1..VehicleCount, j in 1..CustomerCount)(arrival_time[i,j] >= CustomerLBTW[j] /\ arrival_time[i,j] <= CustomerUBTW[j]); % time window constraint
constraint forall(i in 1..VehicleCount, j in 1..CustomerCount, k in 1..CustomerCount)(if x[i,j] = 1 /\ x[i,k] = 1 then arrival_time[i,k] >= arrival_time[i,j] + CustomerServiceTime[j] + CustomerDistance[j,k] endif); % service time and travel time constraint

% Objective
var int: total_cost = sum(i in 1..VehicleCount, j in 1..CustomerCount, k in 1..CustomerCount)(x[i,j]*x[i,k]*CustomerDistance[j,k]);
solve minimize total_cost;

% Output
output ["total cost: ", show(total_cost), "\n"] ++ ["vehicle ", show(i), " serves customer ", show(j), " at time ", show(arrival_time[i,j]), "\n" | i in 1..VehicleCount, j in 1..CustomerCount where x[i,j] = 1];