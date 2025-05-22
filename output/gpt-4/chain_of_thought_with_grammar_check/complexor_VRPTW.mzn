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
array[1..VehicleCount, 1..CustomerCount] of var 0..1: VehicleCustomerAssignment;
array[1..VehicleCount, 1..CustomerCount] of var 0..sum(CustomerDistance): VehicleCustomerDistance;
array[1..VehicleCount, 1..CustomerCount] of var 0..sum(CustomerUBTW): VehicleCustomerTime;

% Constraints
% Each customer must be assigned to exactly one vehicle
constraint forall(i in 1..CustomerCount) (
  sum(j in 1..VehicleCount) (VehicleCustomerAssignment[j, i]) = 1
);

% The total demand of customers assigned to a vehicle must not exceed its capacity
constraint forall(j in 1..VehicleCount) (
  sum(i in 1..CustomerCount) (VehicleCustomerAssignment[j, i] * CustomerDemand[i]) <= VehicleCapacity[j]
);

% The time of service for each customer must be within its time window
constraint forall(j in 1..VehicleCount, i in 1..CustomerCount) (
  if VehicleCustomerAssignment[j, i] = 1 then (VehicleCustomerTime[j, i] >= CustomerLBTW[i] /\ VehicleCustomerTime[j, i] <= CustomerUBTW[i]) endif
);

% The distance travelled by each vehicle must be equal to the sum of distances between assigned customers
constraint forall(j in 1..VehicleCount) (
  VehicleCustomerDistance[j, i] = sum(i in 1..CustomerCount) (VehicleCustomerAssignment[j, i] * CustomerDistance[i, i+1])
);

% Objective
var int: TotalDistance = sum(j in 1..VehicleCount, i in 1..CustomerCount) (VehicleCustomerAssignment[j, i] * VehicleCustomerDistance[j, i]);
solve minimize TotalDistance;