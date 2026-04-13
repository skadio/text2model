int: N;
int: M;

array[1..N] of int: Available;
array[1..N, 1..M] of int: Requirements;

array[1..M] of float: Prices;
array[1..M] of float: Costs;
array[1..M] of int: Demands;

array[1..M] of var 0..max(Demands): x;

constraint
  forall(i in 1..N) (
    sum(j in 1..M) (Requirements[i,j] * x[j]) <= Available[i]
  );

constraint
  forall(j in 1..M) (
    x[j] <= Demands[j]
  );

var float: Profit = sum(j in 1..M) ((Prices[j] - Costs[j]) * int2float(x[j]));

solve maximize Profit;

output [
  "x = ", show(x), "\n",
  "Profit = ", show(Profit), "\n"
];