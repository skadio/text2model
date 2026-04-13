int: M;
int: P;

array[1..M, 1..P] of float: TimeRequired;
array[1..M] of float: MachineCosts;
array[1..M] of float: Availability;
array[1..P] of float: Prices;
array[1..P] of int: MinBatches;

array[1..P] of var int: Batches;

constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

constraint forall(m in 1..M-2) (
  sum(p in 1..P)(TimeRequired[m,p] * int2float(Batches[p])) <= Availability[m]
);

constraint
  sum(p in 1..P)(
    (TimeRequired[M-1,p] + TimeRequired[M,p]) * int2float(Batches[p])
  ) <= Availability[M-1] + Availability[M];

var float: Revenue = sum(p in 1..P)(Prices[p] * int2float(Batches[p]));

var float: OperatingCost =
  sum(m in 1..M-2, p in 1..P)(
    MachineCosts[m] * TimeRequired[m,p] * int2float(Batches[p])
  )
  +
  sum(p in 1..P)(
    (MachineCosts[M-1] * TimeRequired[M-1,p] + MachineCosts[M] * TimeRequired[M,p])
    * int2float(Batches[p])
  );

var float: Profit = Revenue - OperatingCost;

solve maximize Profit;

output [
  "Batches = ", show(Batches), "\n",
  "Profit = ", show(Profit), "\n",
  "Revenue = ", show(Revenue), "\n",
  "OperatingCost = ", show(OperatingCost), "\n"
];