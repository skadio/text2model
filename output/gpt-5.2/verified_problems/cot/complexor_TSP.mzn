% Parameters
int: OriginNum;
int: DestinationNum;

set of int: ORIGINS = 1..OriginNum;
set of int: DESTINATIONS = 1..DestinationNum;

array[ORIGINS] of int: Supply;
array[DESTINATIONS] of int: Demand;
array[ORIGINS, DESTINATIONS] of int: Cost;

% Variables
array[ORIGINS, DESTINATIONS] of var 0..max(Supply): Ship;
var int: TotalCost;

% Constraints
constraint forall(i in ORIGINS, j in DESTINATIONS) (
  Ship[i,j] >= 0
);

constraint forall(i in ORIGINS) (
  sum(j in DESTINATIONS)(Ship[i,j]) <= Supply[i]
);

constraint forall(j in DESTINATIONS) (
  sum(i in ORIGINS)(Ship[i,j]) = Demand[j]
);

constraint TotalCost = sum(i in ORIGINS, j in DESTINATIONS)(Cost[i,j] * Ship[i,j]);

% Objective
solve minimize TotalCost;