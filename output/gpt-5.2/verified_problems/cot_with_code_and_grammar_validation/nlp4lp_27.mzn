int: K;
set of int: I = 1..K;
set of int: T = 0..5;

array[I,I] of float: InputOne;
array[I] of float: ManpowerOne;

array[I,I] of float: InputTwo;
array[I] of float: ManpowerTwo;

array[I] of float: Stock;
array[I] of float: Capacity;

float: ManpowerLimit;

array[I] of float: Demand;

array[T,I] of var 0.0..1.0e15: Prod;
array[T,I] of var 0.0..1.0e15: Invest;
array[T,I] of var 0.0..1.0e15: Cons;
array[T,I] of var 0.0..1.0e15: StockLevel;
array[T,I] of var 0.0..1.0e15: CapLevel;

var 0.0..1.0e15: TotalCapEnd;

constraint forall(i in I) (
  StockLevel[0,i] = Stock[i] /\
  CapLevel[0,i] = Capacity[i]
);

constraint forall(i in I) (
  CapLevel[1,i] = CapLevel[0,i]
);

constraint forall(t in 2..5, i in I) (
  CapLevel[t,i] = CapLevel[t-1,i] + Invest[t-2,i]
);

constraint forall(t in T, i in I) (
  Prod[t,i] <= CapLevel[t,i]
);

constraint forall(i in I) (
  Cons[0,i] = 0.0
);

constraint forall(t in 1..5, i in I) (
  Cons[t,i] >= Demand[i]
);

constraint forall(t in 0..4, i in I) (
  Prod[t,i] + StockLevel[t,i]
  =
  sum(j in I)(InputOne[i,j] * Prod[t+1,j])
  + sum(j in I)(InputTwo[i,j] * Invest[t,j])
  + Cons[t,i]
  + StockLevel[t+1,i]
);

constraint forall(i in I) (
  Prod[5,i] = sum(j in I)(InputTwo[i,j] * Invest[5,j]) + Cons[5,i]
);

constraint forall(t in T) (
  sum(i in I)(ManpowerOne[i] * Prod[t,i] + ManpowerTwo[i] * Invest[t,i]) <= ManpowerLimit
);

constraint TotalCapEnd = sum(i in I)(CapLevel[5,i]);

solve maximize TotalCapEnd;