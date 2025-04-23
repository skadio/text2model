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
% The order in which each customer is visited by their assigned vehicle
array[1..CustomerCount] of var 1..CustomerCount: CustomerOrder; 
% The time at which each customer is visited
array[1..CustomerCount] of var 0..max(CustomerUBTW): VisitTime; 
% The amount of goods delivered to each customer by their assigned vehicle
array[1..CustomerCount] of var 0..max(VehicleCapacity): DeliveredGoods; 

% Constraints

% Each vehicle must respect its capacity
constraint forall(v in 1..VehicleCount)(
  sum(c in 1..CustomerCount)(if VehicleAssignment[c] = v then CustomerDemand[c] else 0 endif) <= VehicleCapacity[v]
);

% Each customer's demand must be met
constraint forall(c in 1..CustomerCount)(
  DeliveredGoods[c] = CustomerDemand[c]
);

% The time at which each customer is visited must be within their time window
constraint forall(c in 1..CustomerCount)(
  VisitTime[c] >= CustomerLBTW[c] /\ VisitTime[c] <= CustomerUBTW[c]
);

% The time at which each customer is visited must account for the travel time from the previous customer and the service time
constraint forall(c in 2..CustomerCount)(
  VisitTime[c] >= VisitTime[CustomerOrder[c-1]] + CustomerDistance[CustomerOrder[c-1], CustomerOrder[c]] + CustomerServiceTime[CustomerOrder[c-1]]
);

% The order in which customers are visited must be consistent with the vehicle assignments
constraint forall(c1 in 1..CustomerCount, c2 in c1+1..CustomerCount)(
  if VehicleAssignment[c1] = VehicleAssignment[c2] then CustomerOrder[c1] < CustomerOrder[c2] else true endif
);

% Objective
solve minimize sum(c1 in 1..CustomerCount, c2 in 1..CustomerCount) (CustomerDistance[c1, c2] * (VehicleAssignment[c1] = VehicleAssignment[c2]));