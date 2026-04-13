int: K;

set of int: I = 1..K;
set of int: T = 0..5;
set of int: Tp = 0..4;

array[I,I] of float: InputOne;
array[I] of float: ManpowerOne;

array[I,I] of float: InputTwo;
array[I] of float: ManpowerTwo;

array[I] of float: Stock;
array[I] of float: Capacity;

float: ManpowerLimit;
array[I] of float: Demand;

array[T, I] of var float: S;
array[T, I] of var float: Cap;

array[Tp, I] of var float: X;
array[Tp, I, I] of var float: Inv;

constraint forall(i in I) (
  S[0,i] = Stock[i] /\
  Cap[0,i] = Capacity[i]
);

constraint forall(t in T, i in I) (
  S[t,i] >= 0.0 /\
  Cap[t,i] >= 0.0
);

constraint forall(t in Tp, i in I) (
  X[t,i] >= 0.0
);

constraint forall(t in Tp, i in I, j in I) (
  Inv[t,i,j] >= 0.0
);

constraint forall(t in Tp, i in I) (
  X[t,i] <= Cap[t,i]
);

constraint forall(t in Tp) (
  sum(i in I)(ManpowerOne[i] * X[t,i]) +
  sum(i in I, j in I)(ManpowerTwo[j] * Inv[t,i,j])
  <= ManpowerLimit
);

constraint forall(i in I) (
  S[0,i] = sum(j in I)(Inv[0,i,j]) + S[1,i]
);

constraint forall(t in 1..4, i in I) (
  S[t-1,i] + X[t-1,i] =
    Demand[i] +
    sum(p in I)(InputOne[i,p] * X[t,p]) +
    sum(j in I)(Inv[t,i,j]) +
    S[t,i]
);

constraint forall(i in I) (
  S[4,i] + X[4,i] = Demand[i] + S[5,i]
);

constraint forall(i in I) (
  Cap[1,i] = Cap[0,i]
);

constraint forall(t in 2..5, j in I) (
  Cap[t,j] = Cap[t-1,j] + sum(i in I)(Inv[t-2,i,j])
);

solve maximize sum(i in I)(Cap[5,i]);