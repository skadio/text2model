int: M;
int: N;

array[1..N] of int: Available;
array[1..N, 1..M] of int: Requirements;
array[1..M] of int: Prices;

array[1..M] of var 0..max(Available): Produce;

var int: TotalRevenue = sum(j in 1..M)(Prices[j] * Produce[j]);

constraint
  forall(i in 1..N)(
    sum(j in 1..M)(Requirements[i, j] * Produce[j]) <= Available[i]
  );

solve maximize TotalRevenue;