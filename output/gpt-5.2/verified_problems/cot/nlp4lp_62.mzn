% Parameters
int: M;
int: P;

array[1..M, 1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;
array[1..P] of int: Prices;
array[1..P] of int: SetupTime;

% Variables
array[1..P] of var 0..max(Availability): Batches;
array[1..P] of var bool: Produce;

% Constraints
constraint
  forall(p in 1..P) (
    Batches[p] >= bool2int(Produce[p])
  );

constraint
  forall(p in 1..P) (
    Batches[p] <= max(Availability) * bool2int(Produce[p])
  );

constraint
  forall(m in 1..M) (
    sum(p in 1..P)(
      TimeRequired[m,p] * Batches[p]
    )
    + (if m == 1 then sum(p in 1..P)(SetupTime[p] * bool2int(Produce[p])) else 0 endif)
    <= Availability[m]
  );

% Objective
var int: Profit =
  sum(p in 1..P)(Prices[p] * Batches[p])
  - sum(m in 1..M)(
      MachineCosts[m] * (
        sum(p in 1..P)(TimeRequired[m,p] * Batches[p])
        + (if m == 1 then sum(p in 1..P)(SetupTime[p] * bool2int(Produce[p])) else 0 endif)
      )
    );

solve maximize Profit;