int: NumParts;
int: NumMachines;

set of int: K = 1..NumParts;
set of int: S = 1..NumMachines;

array[K, S] of float: Time;
array[K] of float: Profit;
array[S] of float: Capacity;

array[K] of var float: QuantityProduced;

constraint
  forall(s in S)(
    sum(k in K)(Time[k, s] * QuantityProduced[k]) <= Capacity[s]
  );

constraint forall(k in K)(QuantityProduced[k] >= 0.0);

var float: TotalProfit = sum(k in K)(Profit[k] * QuantityProduced[k]);

solve maximize TotalProfit;

output [
  "TotalProfit=", show(TotalProfit), "\n",
  "QuantityProduced=", show([QuantityProduced[k] | k in K]), "\n"
];