% Parameters
int: OriginNum;
int: DestinationNum;

array[1..OriginNum] of int: Supply;
array[1..DestinationNum] of int: Demand;
array[1..OriginNum, 1..DestinationNum] of int: Cost;

set of int: ORIGINS = 1..OriginNum;
set of int: DESTINATIONS = 1..DestinationNum;

int: MaxSupply = max(Supply);

% Variables
array[ORIGINS, DESTINATIONS] of var 0..MaxSupply: x;

% Constraints
constraint
  forall(i in ORIGINS)(
    sum(j in DESTINATIONS)( x[i,j] ) <= Supply[i]
  );

constraint
  forall(j in DESTINATIONS)(
    sum(i in ORIGINS)( x[i,j] ) == Demand[j]
  );

% Objective
solve minimize
  sum(i in ORIGINS, j in DESTINATIONS)( Cost[i,j] * x[i,j] );