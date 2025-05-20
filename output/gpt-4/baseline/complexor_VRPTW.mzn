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

% Decision Variables
array[1..VehicleCount, 1..CustomerCount] of var 0..1: x; % x[i,j] = 1 if vehicle i serves customer j
array[1..VehicleCount] of var 0..sum(CustomerDemand): load; % load[i] is the total load of vehicle i
array[1..VehicleCount, 1..CustomerCount] of var 0..sum(CustomerUBTW): time; % time[i,j] is the time when vehicle i arrives at customer j

% Objective
var int: total_cost = sum(i in 1..VehicleCount, j in 1..CustomerCount)(x[i,j]*CustomerDistance[i,j]);
minimize total_cost;

% Constraints
constraint forall(i in 1..VehicleCount)(load[i] = sum(j in 1..CustomerCount)(x[i,j]*CustomerDemand[j]));
constraint forall(i in 1..VehicleCount)(load[i] <= VehicleCapacity[i]);
constraint forall(j in 1..CustomerCount)(sum(i in 1..VehicleCount)(x[i,j]) = 1);
constraint forall(i in 1..VehicleCount, j in 1..CustomerCount)(time[i,j] >= CustomerLBTW[j]);
constraint forall(i in 1..VehicleCount, j in 1..CustomerCount)(time[i,j] <= CustomerUBTW[j]);
constraint forall(i in 1..VehicleCount, j in 1..CustomerCount)(time[i,j] + CustomerServiceTime[j] + CustomerDistance[i,j] <= time[i,j+1] + (1-x[i,j])*sum(CustomerUBTW));