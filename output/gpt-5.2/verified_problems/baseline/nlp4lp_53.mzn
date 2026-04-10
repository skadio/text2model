int: M;
int: P;

array[1..M, 1..P] of float: TimeRequired;
array[1..M] of float: MachineCosts;
array[1..M] of float: Availability;

array[1..P] of float: Prices;
array[1..P] of int: MinBatches;

array[1..M] of float: ExtraCosts;
array[1..M] of float: MaxExtra;

array[1..P] of var int: Batches;
array[1..M] of var float: ExtraHours;

constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

constraint forall(m in 1..M) (
  sum(p in 1..P)(TimeRequired[m,p] * Batches[p]) <= Availability[m] + ExtraHours[m]
);

constraint forall(m in 1..M) (
  0.0 <= ExtraHours[m] /\ ExtraHours[m] <= MaxExtra[m]
);

var float: Revenue = sum(p in 1..P)(Prices[p] * Batches[p]);

var float: RegularOpCost =
  sum(m in 1..M)(
    MachineCosts[m] * sum(p in 1..P)(TimeRequired[m,p] * Batches[p])
  );

var float: ExtraOpCost = sum(m in 1..M)(ExtraCosts[m] * ExtraHours[m]);

var float: Profit = Revenue - RegularOpCost - ExtraOpCost;

solve maximize Profit;

output [
  "Profit=", show(Profit), "\n",
  "Batches=", show(Batches), "\n",
  "ExtraHours=", show(ExtraHours), "\n"
];