int: P;
int: M;
array[1..M, 1..P] of int: TimeRequired;
array[1..M] of int: MachineCosts;
array[1..M] of int: Availability;
array[1..P] of int: Prices;
array[1..P] of int: MinBatches;

int: maxBatches = sum(m in 1..M) Availability[m];

array[1..P] of var 0..maxBatches: batches;

constraint forall(p in 1..P)(batches[p] >= MinBatches[p]);

constraint forall(m in 1..M)(
    sum(p in 1..P)(TimeRequired[m,p] * batches[p]) <= Availability[m]
);

var int: profit = sum(p in 1..P)(Prices[p] * batches[p]) -
                  sum(m in 1..M)(MachineCosts[m] * sum(p in 1..P)(TimeRequired[m,p] * batches[p]));

solve maximize profit;

output [
    "batches: ", show(batches), "\n",
    "profit: ", show(profit), "\n"
];