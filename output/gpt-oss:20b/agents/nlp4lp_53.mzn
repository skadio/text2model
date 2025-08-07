include "globals.mzn";

int: M; int: P;
array[1..M,1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;
array[1..P] of int: Prices;
array[1..P] of int: MinBatches;
array[1..M] of float: ExtraCosts;
array[1..M] of int: MaxExtra;

% Decision variable: number of 100‑part batches produced for each part
array[1..P] of var 0..1000: x;

% Upper bound on batches per part from machine limits
array[1..P] of int: maxBatchPerPart = [
    min([ (Availability[m] + MaxExtra[m]) div TimeRequired[m,p] | m in 1..M ])
    | p in 1..P
];
constraint forall(p in 1..P)( x[p] <= maxBatchPerPart[p] );
constraint forall(p in 1..P)( x[p] >= MinBatches[p] );

% Total hours used on each machine
array[1..M] of var int: totalHours =
    [ sum(p in 1..P)(TimeRequired[m,p] * x[p]) | m in 1..M ];

% Extra hours cannot exceed the allowed maximum
constraint forall(m in 1..M)(
    max(0, totalHours[m] - Availability[m]) <= MaxExtra[m]
);

% Revenue, cost and profit (all as float)
var float: revenue = sum(p in 1..P)(float(Prices[p]) * x[p]);

var float: cost = sum(m in 1..M)(
    MachineCosts[m] * totalHours[m] +
    ExtraCosts[m] * max(0, totalHours[m] - Availability[m])
);

var float: profit = revenue - cost;

solve maximize profit;

output [
  "Profit = ", show(profit), "\n",
  "Batches per part = ", show(x), "\n",
  "Total hours per machine = ", show(totalHours), "\n",
  "Revenue = ", show(revenue), "\n",
  "Cost = ", show(cost), "\n"
];