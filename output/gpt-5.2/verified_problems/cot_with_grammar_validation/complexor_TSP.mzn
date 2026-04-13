% Parameters
int: OriginNum;
int: DestinationNum;

set of int: ORIGINS = 1..OriginNum;
set of int: DESTINATIONS = 1..DestinationNum;

array[ORIGINS] of int: Supply;
array[DESTINATIONS] of int: Demand;
array[ORIGINS, DESTINATIONS] of int: Cost;

% Variables
int: TotalSupply = sum(o in ORIGINS)(Supply[o]);
int: TotalDemand = sum(d in DESTINATIONS)(Demand[d]);

array[ORIGINS, DESTINATIONS] of var 0..TotalSupply: Ship;

var int: TotalCost = sum(o in ORIGINS, d in DESTINATIONS)(Cost[o,d] * Ship[o,d]);

% Constraints
constraint forall(o in ORIGINS)(
  sum(d in DESTINATIONS)(Ship[o,d]) <= Supply[o]
);

constraint forall(d in DESTINATIONS)(
  sum(o in ORIGINS)(Ship[o,d]) = Demand[d]
);

constraint TotalSupply >= TotalDemand;

% Objective
solve minimize TotalCost;