int: K;

array[1..K, 1..K] of float: InputOne;
array[1..K] of float: ManpowerOne;

array[1..K, 1..K] of float: InputTwo;
array[1..K] of float: ManpowerTwo;

array[1..K] of float: Stock;
array[1..K] of float: Capacity;

float: ManpowerLimit;

set of int: I = 1..K;
set of int: T = 0..K;

array[T, I] of var float: Prod;
array[T, I] of var float: Build;
array[T, I] of var float: UseCons;
array[T, I] of var float: UseInv;
array[T, I] of var float: EndStock;
array[T, I] of var float: Cap;

var float: TotalLastTwo;

constraint
  forall(t in T, i in I) (
    Prod[t,i] >= 0.0 /\
    Build[t,i] >= 0.0 /\
    UseCons[t,i] >= 0.0 /\
    UseInv[t,i] >= 0.0 /\
    EndStock[t,i] >= 0.0 /\
    Cap[t,i] >= 0.0
  );

constraint
  forall(i in I) (
    Cap[0,i] = Capacity[i] /\
    EndStock[0,i] = Stock[i]
  );

constraint forall(i in I) (Cap[1,i] = Cap[0,i]);

constraint
  forall(t in 2..K, i in I) (
    Cap[t,i] = Cap[t-1,i] + Build[t-2,i]
  );

constraint
  forall(t in T, i in I) (
    Prod[t,i] <= Cap[t,i]
  );

constraint
  forall(t in 0..K-1, i in I) (
    UseCons[t,i] = sum(j in I) (InputOne[i,j] * Prod[t+1,j])
  );

constraint
  forall(t in T, i in I) (
    UseInv[t,i] = sum(j in I) (InputTwo[i,j] * Build[t,j])
  );

constraint
  forall(t in T, i in I) (
    EndStock[t,i] =
      (if t = 0 then Stock[i] else EndStock[t-1,i] endif)
      + Prod[t,i] - UseCons[t,i] - UseInv[t,i]
  );

constraint forall(i in I) (UseCons[K,i] = 0.0);

constraint
  forall(t in 0..K-1) (
    sum(i in I) (ManpowerOne[i] * Prod[t+1,i] + ManpowerTwo[i] * Build[t,i]) <= ManpowerLimit
  );

constraint
  sum(i in I) (ManpowerTwo[i] * Build[K,i]) <= ManpowerLimit;

constraint
  TotalLastTwo = sum(i in I) (Prod[K-1,i] + Prod[K,i]);

solve maximize TotalLastTwo;