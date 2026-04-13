int: P;
int: C;

set of int: PLANTS = 1..P;
set of int: CITIES = 1..C;

array[PLANTS] of int: Supply;
array[CITIES] of int: Demand;
array[PLANTS, CITIES] of int: TransmissionCosts;

array[PLANTS, CITIES] of var 0..max(Supply): Flow;

constraint
  forall(p in PLANTS) (
    sum(c in CITIES)(Flow[p, c]) <= Supply[p]
  );

constraint
  forall(c in CITIES) (
    sum(p in PLANTS)(Flow[p, c]) == Demand[c]
  );

var int: TotalCost = sum(p in PLANTS, c in CITIES)(TransmissionCosts[p, c] * Flow[p, c]);

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "Flow =\n",
  concat([ concat([ show(Flow[p,c]) ++ if c == C then "\n" else " " endif
                  | c in CITIES ])
         | p in PLANTS ])
];