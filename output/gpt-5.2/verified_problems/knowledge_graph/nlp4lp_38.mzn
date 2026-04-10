int: N;
set of int: T = 1..N;

int: Capacity;
int: HoldingCost;

array[T] of int: Price;
array[T] of int: Cost;

array[T] of var 0..Capacity: Buy;
array[T] of var 0..Capacity: Sell;
array[0..N] of var 0..Capacity: Stock;

constraint Stock[0] = 0;
constraint Stock[N] = 0;

constraint
  forall(t in T) (
    Stock[t] = Stock[t-1] + Buy[t] - Sell[t]
  );

constraint
  forall(t in 0..N) (
    Stock[t] <= Capacity
  );

var int: Profit =
  sum(t in T)(Price[t] * Sell[t] - Cost[t] * Buy[t] - HoldingCost * Stock[t]);

solve maximize Profit;

output [
  "Profit = ", show(Profit), "\n",
  "Buy = ", show(Buy), "\n",
  "Sell = ", show(Sell), "\n",
  "Stock = ", show(Stock), "\n"
];