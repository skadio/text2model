int: M;
int: P;

set of int: MACHINES = 1..M;
set of int: PARTS = 1..P;

array[MACHINES, PARTS] of int: TimeRequired;
array[MACHINES] of int: MachineCosts;
array[MACHINES] of int: Availability;
array[PARTS] of int: Prices;
array[PARTS] of int: MinBatches;

array[PARTS] of var 0..int_max: Batches;

constraint
  forall(p in PARTS) (
    Batches[p] >= MinBatches[p]
  );

% Availability constraints for machines 1..M-2 (individual limits)
constraint
  forall(m in MACHINES where m <= M-2) (
    sum(p in PARTS)(TimeRequired[m,p] * Batches[p]) <= Availability[m]
  );

% Shared availability constraint for machines M-1 and M (if M >= 2)
constraint
  (M < 2) \/
  ( sum(p in PARTS)(TimeRequired[M-1,p] * Batches[p]) +
    sum(p in PARTS)(TimeRequired[M,p] * Batches[p])
    <= Availability[M-1] + Availability[M]
  );

var int: Revenue = sum(p in PARTS)(Prices[p] * Batches[p]);

var int: OperatingCost =
  sum(m in MACHINES, p in PARTS)(MachineCosts[m] * TimeRequired[m,p] * Batches[p]);

var int: Profit = Revenue - OperatingCost;

solve maximize Profit;

output [
  "Batches = ", show(Batches), "\n",
  "Revenue = ", show(Revenue), "\n",
  "OperatingCost = ", show(OperatingCost), "\n",
  "Profit = ", show(Profit), "\n"
];