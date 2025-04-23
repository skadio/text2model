% Parameters
int: NumPorts; % Number of Ports
int: NumTerminals; % Number of Terminals
array[1..NumTerminals, 1..NumPorts] of int: Cost; % Cost of transportation for route from terminal to port
array[1..NumPorts] of int: Demand; % Demand at each destination port
array[1..NumTerminals] of int: Supply; % Supply at each source terminal

% Variables
array[1..NumTerminals, 1..NumPorts] of var 0..max(Supply)+max(Demand): Transport; % Quantity of soybeans to transport from each terminal to each port

% Constraints

% The total quantity of soybeans transported from each terminal should not exceed its supply
constraint forall(k in 1..NumTerminals) (
    sum(l in 1..NumPorts) (Transport[k, l]) <= Supply[k]
);

% The total quantity of soybeans transported to each port should meet its demand
constraint forall(l in 1..NumPorts) (
    sum(k in 1..NumTerminals) (Transport[k, l]) >= Demand[l]
);

% The quantity of soybeans transported along each route should be non-negative
constraint forall(k in 1..NumTerminals, l in 1..NumPorts) (
    Transport[k, l] >= 0
);

% Objective
solve minimize sum(k in 1..NumTerminals, l in 1..NumPorts) (Cost[k, l] * Transport[k, l]);