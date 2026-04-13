int: M;
int: P;

array[1..M, 1..P] of int: TimeRequired;
array[1..M] of float: MachineCosts;
array[1..M] of int: Availability;

array[1..P] of float: Prices;
array[1..P] of int: MinBatches;

array[1..M] of float: ExtraCosts;
array[1..M] of int: MaxExtra;

array[1..P] of var int: Batches;
array[1..M] of var int: ExtraHours;

constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

constraint forall(p in 1..P) (
  Batches[p] >= 0
);

constraint forall(m in 1..M) (
  ExtraHours[m] >= 0
);

constraint forall(m in 1..M) (
  ExtraHours[m] <= MaxExtra[m]
);

constraint forall(m in 1..M) (
  sum(p in 1..P) (TimeRequired[m,p] * Batches[p]) <= Availability[m] + ExtraHours[m]
);

solve maximize
  sum(p in 1..P) (Prices[p] * int2float(Batches[p]))
  - sum(m in 1..M) (
      MachineCosts[m] * int2float(sum(p in 1..P) (TimeRequired[m,p] * Batches[p]))
    )
  - sum(m in 1..M) (ExtraCosts[m] * int2float(ExtraHours[m]));