int: M;
int: P;

array[1..M, 1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;
array[1..P] of int: Prices;
array[1..P] of int: MinBatches;
array[1..M] of float: ExtraCosts;
array[1..M] of int: MaxExtra;

array[1..P] of var int: Batches;
array[1..M] of var int: ExtraHours;

constraint
  forall(p in 1..P) (
    Batches[p] >= MinBatches[p]
  ) /\ 
  forall(m in 1..M) (
    sum(p in 1..P) (TimeRequired[m,p] * Batches[p]) <= Availability[m] + ExtraHours[m]
    /\ ExtraHours[m] <= MaxExtra[m]
    /\ ExtraHours[m] >= 0
  );

var float: Profit = 
  sum(p in 1..P) (Batches[p] * Prices[p]) 
  - sum(m in 1..M) (
      sum(p in 1..P) (TimeRequired[m,p] * Batches[p] * MachineCosts[m]) 
      + ExtraHours[m] * ExtraCosts[m]
    );

solve maximize Profit;

output [
  "Batches: " ++ show(Batches) ++ "\n",
  "ExtraHours: " ++ show(ExtraHours) ++ "\n",
  "Profit: " ++ show(Profit) ++ "\n"
];