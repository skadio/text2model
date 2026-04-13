int: T;
array[1..T] of int: Deliver;
int: StorageCost;
int: SwitchCost;

int: TotalDeliver = sum(t in 1..T)(Deliver[t]);

array[1..T] of var 0..TotalDeliver: Produce;
array[0..T] of var 0..TotalDeliver: InvEnd;
array[1..max(1, T-1)] of var 0..TotalDeliver: ProdDiff;

constraint InvEnd[0] = 0;

constraint forall(t in 1..T) (
  InvEnd[t] = InvEnd[t-1] + Produce[t] - Deliver[t]
);

constraint forall(t in 1..T-1) (
  ProdDiff[t] >= Produce[t+1] - Produce[t] /\
  ProdDiff[t] >= Produce[t] - Produce[t+1]
);

var int: TotalCost =
  StorageCost * sum(t in 1..T-1)(InvEnd[t]) +
  SwitchCost  * sum(t in 1..T-1)(ProdDiff[t]);

solve minimize TotalCost;

output [
  "Produce = ", show(Produce), "\n",
  "InvEnd  = ", show(InvEnd), "\n",
  "TotalCost = ", show(TotalCost), "\n"
];