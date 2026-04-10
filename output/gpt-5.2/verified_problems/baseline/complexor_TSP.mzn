int: OriginNum;
int: DestinationNum;

set of int: ORIGINS = 1..OriginNum;
set of int: DESTINATIONS = 1..DestinationNum;

array[ORIGINS] of int: Supply;
array[DESTINATIONS] of int: Demand;
array[ORIGINS, DESTINATIONS] of int: Cost;

array[ORIGINS, DESTINATIONS] of var 0..max(Supply): x;

constraint
  forall(i in ORIGINS) (
    sum(j in DESTINATIONS)(x[i,j]) <= Supply[i]
  );

constraint
  forall(j in DESTINATIONS) (
    sum(i in ORIGINS)(x[i,j]) = Demand[j]
  );

var int: TotalCost = sum(i in ORIGINS, j in DESTINATIONS)(Cost[i,j] * x[i,j]);

solve minimize TotalCost;

output [
  "TotalCost=", show(TotalCost), "\n",
  "x=\n",
  concat([ concat([ show(x[i,j]) ++ (if j < DestinationNum then " " else "" endif)
                   | j in DESTINATIONS ]) ++ "\n"
           | i in ORIGINS ])
];