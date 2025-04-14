% Parameters
int: CustomerCount; % Number of customers
int: VehicleCount; % Number of vehicles
set of int: Customers = 1..CustomerCount;
set of int: Vehicles = 1..VehicleCount;

array[Customers] of int: CustomerDemand; % Demand of each customer
array[Customers] of int: CustomerLBTW; % Lower bound of time window for each customer
array[Customers] of int: CustomerUBTW; % Upper bound of time window for each customer
array[Customers, Customers] of int: CustomerDistance; % Distance between customers
array[Customers] of int: CustomerServiceTime; % Service time for each customer
array[Vehicles] of int: VehicleCapacity; % Capacity of each vehicle

% Decision Variables
array[Customers, Vehicles] of var 0..1: x; % x[i, k] = 1 if customer i is served by vehicle k
array[Customers] of var int: ArrivalTime; % Arrival time at each customer
array[Customers] of var int: DepartureTime; % Departure time from each customer

% Objective: Minimize total distance traveled by all vehicles
var int: TotalDistance;
constraint TotalDistance = sum(i in Customers, j in Customers, k in Vehicles) (
    CustomerDistance[i, j] * x[i, k] * x[j, k]
);
solve minimize TotalDistance;

% Constraints
constraint forall(k in Vehicles) (
    sum(i in Customers) (CustomerDemand[i] * x[i, k]) <= VehicleCapacity[k]
);

constraint forall(i in Customers) (
    sum(k in Vehicles) (x[i, k]) = 1
);

constraint forall(i in Customers, j in Customers where i != j, k in Vehicles) (
    x[i, k] + x[j, k] <= 1 \/ DepartureTime[i] + CustomerDistance[i, j] <= ArrivalTime[j]
);

constraint forall(i in Customers) (
    ArrivalTime[i] >= CustomerLBTW[i] /\ ArrivalTime[i] <= CustomerUBTW[i]
);

constraint forall(i in Customers) (
    DepartureTime[i] = ArrivalTime[i] + CustomerServiceTime[i]
);

% Symmetry breaking (optional)
constraint forall(k in Vehicles) (
    x[1, k] = 1
);

% Output
output ["Total Distance: \(TotalDistance)\n"];
output ["Vehicle Routes:\n"];
output [show([i | i in Customers where fix(x[i, k]) = 1]) ++ "\n" | k in Vehicles];