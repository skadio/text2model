% Input Data Nomenclature
int: NumPorts; % Number of Ports
int: NumTerminals; % Number of Terminals
array[1..NumTerminals, 1..NumPorts] of int: Cost; % Cost of transportation for route from k to l
array[1..NumPorts] of int: Demand; % Demand at destination l
array[1..NumTerminals] of int: Supply; % Supply at terminal k

% Variables
array[1..NumTerminals, 1..NumPorts] of var 0..max(Supply): Transport; % Quantity of soybeans transported from terminal k to port l

% Constraints
constraint forall(k in 1..NumTerminals)(sum(l in 1..NumPorts)(Transport[k,l]) = Supply[k]); % Supply constraint
constraint forall(l in 1..NumPorts)(sum(k in 1..NumTerminals)(Transport[k,l]) = Demand[l]); % Demand constraint

% Objective
var int: TotalCost = sum(k in 1..NumTerminals, l in 1..NumPorts)(Cost[k,l]*Transport[k,l]);
solve minimize TotalCost;

% Output
output ["Total Cost: ", show(TotalCost), "\n"] ++
["Transport: ", show(Transport), "\n"];