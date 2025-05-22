int: K;

array[1..K] of float: ManpowerOne;
array[1..K] of float: ManpowerTwo;

array[1..K] of float: Stock;
array[1..K] of float: Capacity;
array[1..K] of float: Demand;

array[1..K, 1..K] of float: InputOne;
array[1..K, 1..K] of float: InputTwo;

float: bigM = 1.0e12;

array[1..K] of var 0.0..bigM: Prod;
array[1..K] of var 0.0..bigM: Build;
array[1..K] of var -bigM..bigM: EndStock;

constraint
  forall(i in 1..K) (
    Prod[i] <= Capacity[i]
  );

constraint
  forall(i in 1..K) (
    Prod[i] + Stock[i] >= Demand[i]
  );

constraint
  forall(i in 1..K) (
    EndStock[i] = Stock[i] + Prod[i] - Demand[i]
  );

constraint
  forall(i in 1..K) (
    EndStock[i] >= 0.0
  );

constraint
  forall(j in 1..K) (
    sum(i in 1..K)(InputOne[i, j] * Prod[i] + InputTwo[i, j] * Build[i]) <= Stock[j] + Prod[j]
  );

solve maximize
  sum(i in 1..K)(ManpowerOne[i] * Prod[i] + ManpowerTwo[i] * Build[i]);