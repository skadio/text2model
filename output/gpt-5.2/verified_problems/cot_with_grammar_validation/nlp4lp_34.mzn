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
array[1..T, 1..K] of var 0..max(NumGenerator): AboveMin;

constraint forall(k in 1..K) (MinLevel[k] <= MaxLevel[k]);

constraint forall(t in 1..T, k in 1..K) (
  On[t,k] <= NumGenerator[k]
);

constraint forall(t in 1..T, k in 1..K) (
  Start[t,k] <= NumGenerator[k]
);

constraint forall(t in 1..T, k in 1..K) (
  AboveMin[t,k] <= On[t,k] * (MaxLevel[k] - MinLevel[k])
);

constraint forall(t in 1..T) (
  sum(k in 1..K) (On[t,k] * MinLevel[k] + AboveMin[t,k]) >= Demand[t]
);

constraint forall(k in 1..K) (
  Start[1,k] = On[1,k]
);

constraint forall(t in 2..T, k in 1..K) (
  Start[t,k] >= On[t,k] - On[t-1,k]
);

var float: TotalCost =
  sum(t in 1..T, k in 1..K) (
    (RunCost[k] * On[t,k])
    + ExtraCost[k] * (int2float(AboveMin[t,k]))
    + (StartCost[k] * Start[t,k])
  );

solve minimize TotalCost;