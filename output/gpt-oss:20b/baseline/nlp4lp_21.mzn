int: M;
int: K;
int: I;

array[1..M] of int: NumMachines;
array[1..K] of int: Profit;
array[1..K, 1..M] of float: Time;
array[1..I, 1..M] of float: Maintain;
array[1..K, 1..I] of int: Limit;
float: StorePrice;
array[1..K] of int: KeepQuantity;
float: WorkHours;

array[1..K, 1..I] of var int: prod;
array[1..K, 1..I] of var int: sell;
array[1..K, 1..I] of var int: store;

constraint
  forall(i in 1..I, m in 1..M) (
    sum(k in 1..K) (float(prod[k,i]) * Time[k,m]) <=
    NumMachines[m] * (WorkHours * 24.0 - Maintain[i,m])
  );

constraint
  forall(k in 1..K) (
    store[k,1] = prod[k,1] - sell[k,1]
  );

constraint
  forall(k in 1..K, i in 2..I) (
    store[k,i] = store[k,i-1] + prod[k,i] - sell[k,i]
  );

constraint
  forall(k in 1..K, i in 1..I) (
    prod[k,i] >= 0 /\ sell[k,i] >= 0 /\ store[k,i] >= 0
  );

constraint
  forall(k in 1..K, i in 1..I) (
    store[k,i] <= Limit[k,i]
  );

constraint
  forall(k in 1..K, i in 1..I) (
    store[k,i] >= KeepQuantity[k]
  );

var float: profit = sum(k in 1..K, i in 1..I) (
    Profit[k] * sell[k,i] - StorePrice * float(store[k,i])
  );

solve maximize profit;

output [
  "Profit: ", show(profit), "\n",
  "Production: ", show(prod), "\n",
  "Selling: ", show(sell), "\n",
  "Storage: ", show(store), "\n"
];