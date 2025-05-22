% Parameters
int: OriginNum;
int: DestinationNum;

array[1..OriginNum] of int: Supply;
array[1..DestinationNum] of int: Demand;
array[1..OriginNum, 1..DestinationNum] of int: Cost;

int: maxSupply = max(Supply);

% Variables
array[1..OriginNum, 1..DestinationNum] of var 0..maxSupply: X;

% Constraints
constraint
  forall(i in 1..OriginNum)(
    sum(j in 1..DestinationNum)(X[i,j]) <= Supply[i]
  );

constraint
  forall(j in 1..DestinationNum)(
    sum(i in 1..OriginNum)(X[i,j]) >= Demand[j]
  );

% Objective
var int: TotalCost = sum(i in 1..OriginNum, j in 1..DestinationNum)(Cost[i,j] * X[i,j]);

solve minimize TotalCost;