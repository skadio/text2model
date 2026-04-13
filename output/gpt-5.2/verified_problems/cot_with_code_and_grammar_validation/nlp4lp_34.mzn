int: T;
int: K;

array[1..T] of int: Demand;

array[1..K] of int: NumGenerator;
array[1..K] of int: MinLevel;
array[1..K] of int: MaxLevel;

array[1..K] of int: RunCost;
array[1..K] of float: ExtraCost;
array[1..K] of int: StartCost;

array[1..T, 1..K] of var 0..max(NumGenerator): On;
array[1..T, 1..K] of var 0..max(NumGenerator): Start;
array[1..T, 1..K] of var 0..max([MaxLevel[k] * NumGenerator[k] | k in 1..K]): Prod;

var float: TotalCost;

constraint forall(k in 1..K) (
  Start[1,k] = On[1,k]
);

constraint forall(t in 2..T, k in 1..K) (
  Start[t,k] >= On[t,k] - On[t-1,k]
);

constraint forall(t in 1..T, k in 1..K) (
  Prod[t,k] >= MinLevel[k] * On[t,k]
);

constraint forall(t in 1..T, k in 1..K) (
  Prod[t,k] <= MaxLevel[k] * On[t,k]
);

constraint forall(t in 1..T) (
  sum(k in 1..K)(Prod[t,k]) >= Demand[t]
);

constraint
  TotalCost =
    sum(t in 1..T, k in 1..K) (
      int2float(RunCost[k] * On[t,k]) +
      ExtraCost[k] * (int2float(Prod[t,k]) - int2float(MinLevel[k] * On[t,k])) +
      int2float(StartCost[k] * Start[t,k])
    );

solve minimize TotalCost;