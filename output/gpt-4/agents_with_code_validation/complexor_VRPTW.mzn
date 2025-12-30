% Parameters
int: CustomerCount; % The number of customers to be supplied
int: VehicleCount; % The number of vehicles available for distribution
array[1..CustomerCount] of int: CustomerDemand; % The demand of each customer
array[1..CustomerCount] of int: CustomerLBTW; % The lower bound of the time window for each customer
array[1..CustomerCount] of int: CustomerUBTW; % The upper bound of the time window for each customer
array[1..CustomerCount, 1..CustomerCount] of int: CustomerDistance; % The distance from each customer to every other customer
array[1..CustomerCount] of int: CustomerServiceTime; % The service time required for each customer
array[1..VehicleCount] of int: VehicleCapacity; % The capacity of each vehicle

% Variables
% The vehicle assigned to each customer
array[1..CustomerCount] of var 1..VehicleCount: VehicleAssignment; 
% The order in which customers are visited by each vehicle
array[1..VehicleCount, 1..CustomerCount] of var 1..CustomerCount: CustomerOrder; 
% The time at which each customer is served
array[1..CustomerCount] of var 0..max(CustomerUBTW): ServiceTime; 
% The amount of goods delivered by each vehicle
array[1..VehicleCount] of var 0..max(VehicleCapacity): VehicleLoad; 

% Constraints

% Each customer must be assigned to exactly one vehicle
constraint forall(i in 1..CustomerCount) (
  sum(j in 1..VehicleCount) (VehicleAssignment[i] = j) = 1
);

% The total demand of customers assigned to a vehicle must not exceed its capacity
constraint forall(j in 1..VehicleCount) (
  sum(i in 1..CustomerCount) (VehicleAssignment[i] = j)*CustomerDemand[i] <= VehicleCapacity[j]
);

% The order of customers visited by a vehicle must be unique
constraint forall(j in 1..VehicleCount) (
  alldifferent(CustomerOrder[j, 1..CustomerCount])
);

% The service time of each customer must be within its time window
constraint forall(i in 1..CustomerCount) (
  ServiceTime[i] >= CustomerLBTW[i] /\ ServiceTime[i] <= CustomerUBTW[i]
);

% The service time of a customer must be greater than the service time of the previous customer plus the travel time and service time
constraint forall(j in 1..VehicleCount, i in 2..CustomerCount) (
  let { var int: prev_customer = CustomerOrder[j, i-1]; var int: curr_customer = CustomerOrder[j, i] } in
  (prev_customer > 0 /\ curr_customer > 0) -> (ServiceTime[curr_customer] >= ServiceTime[prev_customer] + CustomerDistance[prev_customer, curr_customer] + CustomerServiceTime[prev_customer])
);

% The vehicle load must equal the total demand of the customers it serves
constraint forall(j in 1..VehicleCount) (
  VehicleLoad[j] = sum(i in 1..CustomerCount) (VehicleAssignment[i] = j)*CustomerDemand[i]
);

% Objective
solve minimize sum(j in 1..VehicleCount, i in 1..CustomerCount) (
  if i = 1 then
    (VehicleAssignment[CustomerOrder[j, i]] = j)*CustomerDistance[0, CustomerOrder[j, i]]
  elseif i = CustomerCount then
    (VehicleAssignment[CustomerOrder[j, i]] = j)*CustomerDistance[CustomerOrder[j, i], 0]
  else
    (VehicleAssignment[CustomerOrder[j, i]] = j)*CustomerDistance[CustomerOrder[j, i-1], CustomerOrder[j, i]]
  endif
);