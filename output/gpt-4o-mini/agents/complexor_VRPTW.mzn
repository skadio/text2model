include "globals.mzn";

int: CustomerCount;                     % Number of customers
int: VehicleCount;                       % Number of vehicles
array[1..CustomerCount] of int: CustomerDemand;          % Demand of each customer
array[1..CustomerCount] of int: CustomerLBTW;           % Lower bound of time window for each customer
array[1..CustomerCount] of int: CustomerUBTW;           % Upper bound of time window for each customer
array[1..CustomerCount, 1..CustomerCount] of int: CustomerDistance; % Distance between customers
array[1..CustomerCount] of int: CustomerServiceTime;    % Service time required for each customer
array[1..VehicleCount] of int: VehicleCapacity;         % Capacity of each vehicle

% Decision variables
array[1..CustomerCount] of var 0..VehicleCount: assignedVehicle; % Vehicle assigned to each customer
array[1..VehicleCount] of var 0..CustomerCount: load;          % Load of each vehicle
array[1..CustomerCount] of var 0..CustomerCount: arrivalTime;  % Arrival time at each customer

% Constraints
% Each customer must be assigned to exactly one vehicle
constraint forall(c in 1..CustomerCount) (
    assignedVehicle[c] > 0
);

% Vehicle capacity constraints
constraint forall(v in 1..VehicleCount) (
    load[v] <= VehicleCapacity[v]
);

% Demand satisfaction
constraint forall(c in 1..CustomerCount) (
    load[assignedVehicle[c]] + CustomerDemand[c] <= VehicleCapacity[assignedVehicle[c]]
);

% Time window constraints
constraint forall(c in 1..CustomerCount) (
    CustomerLBTW[c] <= arrivalTime[c] /\ arrivalTime[c] <= CustomerUBTW[c]
);

% Objective: Minimize total transportation cost
var int: totalCost = sum(c1 in 1..CustomerCount, c2 in 1..CustomerCount)(CustomerDistance[c1, c2] * (assignedVehicle[c1] == assignedVehicle[c2] ? 1 : 0));
solve minimize totalCost;

% Output
output [
    "Assigned Vehicles: ", show(assignedVehicle), "\n",
    "Total Cost: ", show(totalCost), "\n"
];