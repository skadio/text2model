int: K;

array[1..K] of float: ManpowerOne;
array[1..K] of float: ManpowerTwo;

array[1..K] of float: Stock;
array[1..K] of float: Capacity;
array[1..K] of float: Demand;

array[1..K, 1..K] of float: InputOne;
array[1..K, 1..K] of float: InputTwo;

int: T = 5;

array[1..K, 1..T] of var 0.0..1.0e12: Prod;
array[1..K, 1..T] of var 0.0..1.0e12: Build;

array[1..K, 0..T] of var 0.0..1.0e12: Inv;
array[1..K, 0..T] of var 0.0..1.0e12: Cap;

constraint
  forall(i in 1..K) (
    Inv[i,0] = Stock[i] /\
    Cap[i,0] = Capacity[i]
  );

constraint
  forall(i in 1..K, t in 1..T) (
    Prod[i,t] <= Cap[i,t]
  );

constraint
  forall(i in 1..K) (
    Cap[i,1] = Cap[i,0] /\
    Cap[i,2] = Cap[i,1]
  );

constraint
  forall(i in 1..K, t in 3..T) (
    Cap[i,t] = Cap[i,t-1] + Build[i,t-2]
  );

constraint
  forall(i in 1..K, t in 1..T) (
    Inv[i,t] =
      Inv[i,t-1]
      + Prod[i,t]
      - Demand[i]
      - (if t <= T-1 then sum(j in 1..K)(InputOne[i,j] * Prod[j,t+1]) else 0.0 endif)
      - (if t <= T-1 then sum(j in 1..K)(InputTwo[i,j] * Build[j,t+1]) else 0.0 endif)
  );

solve maximize
  sum(t in 1..T)(
    sum(i in 1..K)(ManpowerOne[i] * Prod[i,t] + ManpowerTwo[i] * Build[i,t])
  );