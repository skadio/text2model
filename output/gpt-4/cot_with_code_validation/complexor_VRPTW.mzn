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
array[1..VehicleCount, 1..CustomerCount] of var 0..1: VehicleAssignment;
array[1..VehicleCount] of var 0..sum(CustomerDistance): VehicleTravelTime;
array[1..VehicleCount] of var 0..sum(CustomerServiceTime): VehicleServiceTime;

% Constraints
% Each customer must be served by exactly one vehicle
constraint forall(i in 1..CustomerCount) (
  sum(j in 1..VehicleCount) (VehicleAssignment[j,i]) = 1
);

% The total demand served by each vehicle must not exceed its capacity
constraint forall(j in 1..VehicleCount) (
  sum(i in 1..CustomerCount) (VehicleAssignment[j,i] * CustomerDemand[i]) <= VehicleCapacity[j]
);

% The total travel time for each vehicle must not exceed the upper bound of the time window for each customer
constraint forall(j in 1..VehicleCount) (
  VehicleTravelTime[j] + VehicleServiceTime[j] <= sum(i in 1..CustomerCount) (VehicleAssignment[j,i] * CustomerUBTW[i])
);

% The total travel time for each vehicle must not be less than the lower bound of the time window for each customer
constraint forall(j in 1..VehicleCount) (
  VehicleTravelTime[j] + VehicleServiceTime[j] >= sum(i in 1..CustomerCount) (VehicleAssignment[j,i] * CustomerLBTW[i])
);

% The travel time for each vehicle must be equal to the sum of the distances to the customers it serves
constraint forall(j in 1..VehicleCount) (
  VehicleTravelTime[j] = sum(i in 1..CustomerCount) (VehicleAssignment[j,i] * sum(k in 1..CustomerCount) (VehicleAssignment[j,k] * CustomerDistance[i,k]))
);

% The service time for each vehicle must be equal to the sum of the service times of the customers it serves
constraint forall(j in 1..VehicleCount) (
  VehicleServiceTime[j] = sum(i in 1..CustomerCount) (VehicleAssignment[j,i] * CustomerServiceTime[i])
);

% Objective
var int: TotalCost = sum(j in 1..VehicleCount) (VehicleTravelTime[j]);
solve minimize TotalCost;