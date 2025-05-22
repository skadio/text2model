% Parameters
int: NumPorts;
int: NumTerminals;

array[1..NumTerminals, 1..NumPorts] of int: Cost;
array[1..NumPorts] of int: Demand;
array[1..NumTerminals] of int: Supply;

% Auxiliary parameter
int: TotalSupply = sum(k in 1..NumTerminals)(Supply[k]);

% Variables
array[1..NumTerminals, 1..NumPorts] of var 0..TotalSupply: Flow;

% Constraints
% Each terminal ships all of its available supply
constraint
  forall(k in 1..NumTerminals)(
    sum(l in 1..NumPorts)(Flow[k,l]) = Supply[k]
  );

% Each destination receives exactly its demand
constraint
  forall(l in 1..NumPorts)(
    sum(k in 1..NumTerminals)(Flow[k,l]) = Demand[l]
  );

% Objective
solve minimize
  sum(k in 1..NumTerminals, l in 1..NumPorts)(Cost[k,l] * Flow[k,l]);