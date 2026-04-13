int: K;
int: S;

set of int: PARTS = 1..K;
set of int: MACHINES = 1..S;

array[PARTS, MACHINES] of int: Time;
array[PARTS] of int: Profit;
array[MACHINES] of int: Capacity;

array[PARTS] of var int: x;

constraint forall(k in PARTS)(x[k] >= 0);

constraint
  forall(s in MACHINES)(
    sum(k in PARTS)(Time[k,s] * x[k]) <= Capacity[s]
  );

var int: TotalProfit = sum(k in PARTS)(Profit[k] * x[k]);

solve maximize TotalProfit;

output [
  "TotalProfit=", show(TotalProfit), "\n",
  "x=", show(x), "\n"
];