int: T;
array[1..T] of int: Deliver;
int: StorageCost;
int: SwitchCost;

array[1..T] of var int: Prod;
array[0..T] of var int: Inv;
array[1..T-1] of var int: SwitchAbs;

constraint Inv[0] = 0;
constraint Inv[T] = 0;

constraint forall(t in 1..T) (
  Inv[t] = Inv[t-1] + Prod[t] - Deliver[t]
);

constraint forall(t in 0..T) (Inv[t] >= 0);
constraint forall(t in 1..T) (Prod[t] >= 0);

constraint forall(t in 1..T-1) (
  SwitchAbs[t] = abs(Prod[t+1] - Prod[t])
);

solve minimize
  StorageCost * sum(t in 1..T-1)(Inv[t]) +
  SwitchCost * sum(t in 1..T-1)(SwitchAbs[t]);