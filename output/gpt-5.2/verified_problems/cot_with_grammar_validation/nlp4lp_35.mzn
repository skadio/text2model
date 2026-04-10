int: NumProducts;
int: NumMachines;

set of int: K = 1..NumProducts;
set of int: S = 1..NumMachines;

array[K, S] of int: ProduceTime;
array[S] of int: AvailableTime;
array[K] of int: Profit;

array[K] of var int: Qty;

constraint forall(k in K) (Qty[k] >= 0);

constraint
  forall(s in S) (
    sum(k in K) (ProduceTime[k, s] * Qty[k]) <= AvailableTime[s]
  );

solve maximize sum(k in K) (Profit[k] * Qty[k]);