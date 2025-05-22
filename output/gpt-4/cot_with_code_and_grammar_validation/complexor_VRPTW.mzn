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
array[1..VehicleCount, 1..CustomerCount] of var 0..sum(CustomerDemand): load; % load[i,j] is the load of vehicle i after serving customer j
array[1..VehicleCount, 1..CustomerCount] of var 0..sum(CustomerUBTW): time; % time[i,j] is the time at which vehicle i serves customer j

% Constraints
% Each customer is served by exactly one vehicle
constraint forall(j in 1..CustomerCount) (
  sum(i in 1..VehicleCount) (x[i,j]) = 1
);

% The load of each vehicle does not exceed its capacity
constraint forall(i in 1..VehicleCount, j in 1..CustomerCount) (
  load[i,j] <= VehicleCapacity[i]
);

% The load of each vehicle after serving a customer is equal to its load before serving the customer plus the customer's demand
constraint forall(i in 1..VehicleCount, j in 2..CustomerCount) (
  load[i,j] = load[i,j-1] + x[i,j]*CustomerDemand[j]
);

% The time at which each vehicle serves a customer is within the customer's time window
constraint forall(i in 1..VehicleCount, j in 1..CustomerCount) (
  time[i,j] >= CustomerLBTW[j]
  /\ time[i,j] <= CustomerUBTW[j]
);

% The time at which each vehicle serves a customer is equal to the time at which it served the previous customer plus the distance between the customers and the service time of the previous customer
constraint forall(i in 1..VehicleCount, j in 2..CustomerCount) (
  time[i,j] = time[i,j-1] + CustomerDistance[j-1,j] + CustomerServiceTime[j-1]
);

% Objective
var int: total_distance = sum(i in 1..VehicleCount, j in 1..CustomerCount) (x[i,j]*CustomerDistance[j,j mod CustomerCount + 1]);
solve minimize total_distance;