int: M;
int: P;

array[1..M, 1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;
array[1..P] of int: Prices;
array[1..P] of int: MinBatches;
array[1..M] of float: ExtraCosts;
array[1..M] of int: MaxExtra;

int: max_batches =
  max([ (Availability[m] + MaxExtra[m]) div max([ TimeRequired[m,p] | p in 1..P where TimeRequired[m,p] > 0 ])
      | m in 1..M ]);

array[1..P] of var 0..max_batches: Batches;
array[1..M] of var 0..max([Availability[m] + MaxExtra[m] | m in 1..M]): UsedHours;
array[1..M] of var 0..max([MaxExtra[m] | m in 1..M]): ExtraHours;

var float: Profit;

constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

constraint forall(m in 1..M) (
  UsedHours[m] = sum(p in 1..P)(TimeRequired[m,p] * Batches[p])
);

constraint forall(m in 1..M) (
  UsedHours[m] <= Availability[m] + ExtraHours[m]
);

constraint forall(m in 1..M) (
  ExtraHours[m] <= MaxExtra[m]
);

constraint
  Profit =
    sum(p in 1..P)(Prices[p] * Batches[p])
    - sum(m in 1..M)(
        MachineCosts[m] * UsedHours[m] + ExtraCosts[m] * int2float(ExtraHours[m])
      );

solve maximize Profit;