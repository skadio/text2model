int: OriginNum;
int: DestinationNum;

set of int: ORIGINS = 1..OriginNum;
set of int: DESTINATIONS = 1..DestinationNum;

array[ORIGINS] of int: Supply;
array[DESTINATIONS] of int: Demand;
array[ORIGINS, DESTINATIONS] of float: Cost;

array[ORIGINS, DESTINATIONS] of var int: Ship;

constraint
  forall(i in ORIGINS, j in DESTINATIONS) (
    Ship[i,j] >= 0
  );

constraint
  forall(i in ORIGINS) (
    sum(j in DESTINATIONS)(Ship[i,j]) <= Supply[i]
  );

constraint
  forall(j in DESTINATIONS) (
    sum(i in ORIGINS)(Ship[i,j]) == Demand[j]
  );

var float: TotalCost = sum(i in ORIGINS, j in DESTINATIONS)(Cost[i,j] * int2float(Ship[i,j]));

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "Ship =\n",
  concat([ concat([ show(Ship[i,j]) ++ if j == DestinationNum then "\n" else " " endif
                  | j in DESTINATIONS ])
          | i in ORIGINS ])
];