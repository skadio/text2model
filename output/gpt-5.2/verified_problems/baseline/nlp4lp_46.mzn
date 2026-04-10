int: N;
int: M;

array[1..N] of int: Available;
array[1..N, 1..M] of int: Requirements;

array[1..M] of int: Prices;
array[1..M] of int: Costs;
array[1..M] of int: Demands;

array[1..M] of int: ProfitPerUnit = [Prices[j] - Costs[j] | j in 1..M];

array[1..M] of var 0..Demands[j]: x;

constraint
  forall(i in 1..N) (
    sum(j in 1..M) (Requirements[i,j] * x[j]) <= Available[i]
  );

var int: TotalProfit = sum(j in 1..M) (ProfitPerUnit[j] * x[j]);

solve maximize TotalProfit;

output [
  "x = ", show(x), "\n",
  "TotalProfit = ", show(TotalProfit), "\n"
];