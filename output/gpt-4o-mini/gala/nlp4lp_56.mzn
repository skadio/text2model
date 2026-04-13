include "globals.mzn";

int: NumPorts;                     % Number of Ports
int: NumTerminals;                 % Number of Terminals
array[1..NumTerminals, 1..NumPorts] of int: Cost; % Cost of transportation
array[1..NumPorts] of int: Demand; % Demand at each destination
array[1..NumTerminals] of int: Supply; % Supply at each terminal

% Decision variables: amount of soybeans transported from terminal k to port l
array[1..NumTerminals, 1..NumPorts] of var 0..max(Supply): Transport;

% Constraints to ensure that supply is not exceeded
constraint forall(k in 1..NumTerminals)(
    sum(l in 1..NumPorts)(Transport[k, l]) <= Supply[k]
);

% Constraints to ensure that demand is met
constraint forall(l in 1..NumPorts)(
    sum(k in 1..NumTerminals)(Transport[k, l]) >= Demand[l]
);

% Objective: Minimize total transportation cost
var int: TotalCost = sum(k in 1..NumTerminals, l in 1..NumPorts)(Cost[k, l] * Transport[k, l]);

solve minimize TotalCost;

output [ "Total Cost = ", show(TotalCost), "\nTransport = ", show(Transport), "\n" ];