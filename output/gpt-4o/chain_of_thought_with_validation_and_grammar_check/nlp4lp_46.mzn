int: N;
int: M;

array[1..N] of int: Available;
array[1..N, 1..M] of int: Requirements;
array[1..M] of int: Prices;
array[1..M] of int: Costs;
array[1..M] of int: Demands;

int: MaxDemand = max(Demands);

array[1..M] of var 0..MaxDemand: Production;

constraint
  forall(j in 1..M)(
    Production[j] <= Demands[j]
  );

constraint
  forall(i in 1..N)(
    sum(j in 1..M)(Requirements[i,j] * Production[j]) <= Available[i]
  );

var int: Profit = sum(j in 1..M)((Prices[j] - Costs[j]) * Production[j]);

solve maximize Profit;