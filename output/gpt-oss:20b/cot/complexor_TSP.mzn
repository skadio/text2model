% Parameters
int: OriginNum;
int: DestinationNum;
array[1..OriginNum] of int: Supply;
array[1..DestinationNum] of int: Demand;
array[1..OriginNum, 1..DestinationNum] of int: Cost;
int: maxSupply = max(Supply);

% Variables
array[1..OriginNum, 1..DestinationNum] of var 0..maxSupply: x;

% Constraints
constraint
  forall(i in 1..OriginNum) (
    sum(j in 1..DestinationNum)(x[i,j]) <= Supply[i]
  );

constraint
  forall(j in 1..DestinationNum) (
    sum(i in 1..OriginNum)(x[i,j]) = Demand[j]
  );

constraint
  forall(i in 1..OriginNum, j in 1..DestinationNum) (
    x[i,j] <= Supply[i]
  );

% Objective
solve minimize
  sum(i in 1..OriginNum, j in 1..DestinationNum)(Cost[i,j] * x[i,j]);