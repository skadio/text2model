int: NumProducts;
int: NumMachines;

set of int: K = 1..NumProducts;
set of int: S = 1..NumMachines;

array[K, S] of int: ProduceTime;
array[S] of int: AvailableTime;
array[K] of int: Profit;

array[K] of var 0..int_max: Quantity;

constraint
  forall(s in S) (
    sum(k in K)(ProduceTime[k, s] * Quantity[k]) <= AvailableTime[s]
  );

var int: TotalProfit = sum(k in K)(Profit[k] * Quantity[k]);

solve maximize TotalProfit;

output [
  "TotalProfit=", show(TotalProfit), "\n",
  "Quantity=", show(Quantity), "\n"
];