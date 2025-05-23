% Parameters
int: NumPorts;
int: NumTerminals;
array[1..NumTerminals, 1..NumPorts] of int: Cost;
array[1..NumPorts] of int: Demand;
array[1..NumTerminals] of int: Supply;

% Variables
array[1..NumTerminals, 1..NumPorts] of var 0..max(Supply): Transport;

% Constraints
constraint forall(k in 1..NumTerminals)(sum(l in 1..NumPorts)(Transport[k,l]) = Supply[k]);
constraint forall(l in 1..NumPorts)(sum(k in 1..NumTerminals)(Transport[k,l]) = Demand[l]);

% Objective
solve minimize sum(k in 1..NumTerminals, l in 1..NumPorts)(Cost[k,l]*Transport[k,l]);