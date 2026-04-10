% Parameters
int: M;
int: P;

array[1..M, 1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;

array[1..P] of int: Prices;
array[1..P] of int: MinBatches;

array[1..M] of float: ExtraCosts;
array[1..M] of int: MaxExtra;

% Variables
array[1..P] of var int: Batches;
array[1..M] of var int: ExtraHours;

var float: Profit;

% Constraints
constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

constraint forall(m in 1..M) (
  ExtraHours[m] >= 0 /\
  ExtraHours[m] <= MaxExtra[m]
);

constraint forall(m in 1..M) (
  sum(p in 1..P)( TimeRequired[m,p] * Batches[p] )
  <= Availability[m] + ExtraHours[m]
);

% Objective
constraint
  Profit =
    sum(p in 1..P)( int2float(Prices[p]) * int2float(Batches[p]) )
    - sum(m in 1..M)(
        int2float(MachineCosts[m]) * int2float(sum(p in 1..P)(TimeRequired[m,p] * Batches[p]))
        + ExtraCosts[m] * int2float(ExtraHours[m])
      );

solve maximize Profit;