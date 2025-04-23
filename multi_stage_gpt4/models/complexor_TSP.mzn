% Parameters
int: OriginNum; % The total number of origins
int: DestinationNum; % The total number of destinations
array[1..OriginNum] of int: Supply; % The supply of goods available at each origin
array[1..DestinationNum] of int: Demand; % The demand for goods to be satisfied at each destination
array[1..OriginNum, 1..DestinationNum] of int: Cost; % The cost of transporting goods from origin i to destination j per good

% Variables
array[1..OriginNum, 1..DestinationNum] of var 0..max(Supply)+max(Demand): Transport; % The amount of goods transported from each origin to each destination

% Constraints

% Constraint 1: The total amount of goods transported from each origin should not exceed its supply
constraint forall(i in 1..OriginNum) (
  sum(j in 1..DestinationNum) (Transport[i,j]) <= Supply[i]
);

% Constraint 2: The total amount of goods transported to each destination should meet its demand
constraint forall(j in 1..DestinationNum) (
  sum(i in 1..OriginNum) (Transport[i,j]) >= Demand[j]
);

% Constraint 3: The total amount of goods transported from each origin to each destination should be non-negative
constraint forall(i in 1..OriginNum, j in 1..DestinationNum) (
  Transport[i,j] >= 0
);

% Objective
solve minimize sum(i in 1..OriginNum, j in 1..DestinationNum) (Cost[i,j]*Transport[i,j]);