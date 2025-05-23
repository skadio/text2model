include "globals.mzn";

% Number of Ports
int: NumPorts;

% Number of Terminals
int: NumTerminals;

% Cost of transportation for route from k to l
array[1..NumTerminals, 1..NumPorts] of int: Cost;

% Demand at destination l
array[1..NumPorts] of int: Demand;

% Supply at terminal k
array[1..NumTerminals] of int: Supply;

% Decision variable: quantity of soybeans to transport along each route
array[1..NumTerminals, 1..NumPorts] of var 0..max(Supply) + max(Demand): Quantity;

% Objective: Minimize transportation costs
var int: TotalCost = sum(k in 1..NumTerminals, l in 1..NumPorts)(Cost[k,l]*Quantity[k,l]);
minimize TotalCost;

% Constraints
% The total quantity of soybeans transported from each terminal should not exceed its supply
constraint forall(k in 1..NumTerminals)(sum(l in 1..NumPorts)(Quantity[k,l]) <= Supply[k]);

% The total quantity of soybeans transported to each port should meet its demand
constraint forall(l in 1..NumPorts)(sum(k in 1..NumTerminals)(Quantity[k,l]) >= Demand[l]);

solve satisfy;