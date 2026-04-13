int: P;
int: M;

array[1..M, 1..P] of float: TimeRequired;
array[1..M] of float: MachineCosts;
array[1..M] of float: Availability;

array[1..P] of float: Prices;
array[1..P] of int: MinBatches;

array[1..P] of var int: Batches;

constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

constraint forall(m in 1..M) (
  sum(p in 1..P)( TimeRequired[m,p] * int2float(Batches[p]) ) <= Availability[m]
);

array[1..P] of float: UnitCost =
  [ sum(m in 1..M)( TimeRequired[m,p] * MachineCosts[m] ) | p in 1..P ];

var float: Profit =
  sum(p in 1..P)( (Prices[p] - UnitCost[p]) * int2float(Batches[p]) );

solve maximize Profit;

output [
  "Batches = ", show(Batches), "\n",
  "Profit = ", show(Profit), "\n"
];