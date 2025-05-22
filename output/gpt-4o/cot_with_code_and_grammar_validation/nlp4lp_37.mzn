int: K;
int: M;

array[1..K] of float: Price;
array[1..M] of float: Demand;
array[1..K, 1..M] of float: Nutrition;

float: BIG = 1.0e6;

array[1..K] of var 0.0..BIG: x;

constraint
  forall(m in 1..M)(
    sum(k in 1..K)(Nutrition[k, m] * x[k]) >= Demand[m]
  );

solve minimize sum(k in 1..K)(Price[k] * x[k]);