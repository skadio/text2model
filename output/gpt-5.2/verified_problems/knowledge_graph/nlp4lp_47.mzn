int: P;
int: M;

array[1..M, 1..P] of int: TimeRequired;   % hours per batch
array[1..M] of int: MachineCosts;         % cost per hour
array[1..M] of int: Availability;         % available hours per month
array[1..P] of int: Prices;               % revenue per batch
array[1..P] of int: MinBatches;           % minimum batches per part

array[1..P] of var int: Batches;

constraint forall(p in 1..P) (
  Batches[p] >= MinBatches[p]
);

constraint forall(m in 1..M) (
  sum(p in 1..P)(TimeRequired[m,p] * Batches[p]) <= Availability[m]
);

var int: Revenue = sum(p in 1..P)(Prices[p] * Batches[p]);
var int: Cost = sum(m in 1..M)(MachineCosts[m] * sum(p in 1..P)(TimeRequired[m,p] * Batches[p]));
var int: Profit = Revenue - Cost;

solve maximize Profit;

output [
  "Batches = ", show(Batches), "\n",
  "Revenue = ", show(Revenue), "\n",
  "Cost = ", show(Cost), "\n",
  "Profit = ", show(Profit), "\n"
];