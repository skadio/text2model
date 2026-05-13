int: N;
int: M;
array[1..N] of int: Available;
array[1..N, 1..M] of int: Requirements;
array[1..M] of int: Prices;
array[1..M] of int: Costs;
array[1..M] of int: Demands;

array[1..M] of var int: x;

constraint
  forall(j in 1..M) (
    x[j] >= 0 /\ x[j] <= Demands[j]
  );

constraint
  forall(i in 1..N) (
    sum(j in 1..M) Requirements[i,j] * x[j] <= Available[i]
  );

var int: profit = sum(j in 1..M) (Prices[j] - Costs[j]) * x[j];

solve maximize profit;

output [
  "Production: " ++ show(x) ++ "\n",
  "Profit: " ++ show(profit) ++ "\n"
];