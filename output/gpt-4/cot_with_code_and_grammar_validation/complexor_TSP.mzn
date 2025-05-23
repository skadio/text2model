% Parameters
int: OriginNum;
int: DestinationNum;
array[1..OriginNum] of int: Supply;
array[1..DestinationNum] of int: Demand;
array[1..OriginNum, 1..DestinationNum] of int: Cost;

% Variables
array[1..OriginNum, 1..DestinationNum] of var 0..max(Supply)+max(Demand): Transport;

% Constraints
constraint forall(i in 1..OriginNum)(sum(j in 1..DestinationNum)(Transport[i,j]) = Supply[i]);
constraint forall(j in 1..DestinationNum)(sum(i in 1..OriginNum)(Transport[i,j]) = Demand[j]);

% Objective
solve minimize sum(i in 1..OriginNum, j in 1..DestinationNum)(Cost[i,j]*Transport[i,j]);