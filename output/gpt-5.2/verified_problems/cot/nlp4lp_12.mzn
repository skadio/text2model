% Parameters
int: T;
array[1..T] of int: Deliver;
int: StorageCost;
int: SwitchCost;

% Variables
array[1..T] of var int: Produce;
array[0..T] of var int: Inv;
array[1..T-1] of var int: Delta;

% Constraints
constraint Inv[0] = 0;

constraint forall(i in 1..T) (
  Produce[i] >= 0 /\ Inv[i] >= 0
);

constraint forall(i in 1..T) (
  Inv[i] = Inv[i-1] + Produce[i] - Deliver[i]
);

constraint forall(i in 1..T-1) (
  Delta[i] >= 0 /\
  Delta[i] >= Produce[i+1] - Produce[i] /\
  Delta[i] >= Produce[i] - Produce[i+1]
);

constraint Inv[T] = 0;

% Objective
solve minimize
  StorageCost * sum(i in 1..T-1)(Inv[i]) +
  SwitchCost * sum(i in 1..T-1)(Delta[i]);