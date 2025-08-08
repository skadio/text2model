% Parameters
int: P;
int: C;
array[1..P] of int: Supply;
array[1..C] of int: Demand;
array[1..P, 1..C] of int: TransmissionCosts;

% Variables
int: maxSupply = max(Supply);
array[1..P, 1..C] of var 0..maxSupply: x;

% Constraints
constraint
  forall(p in 1..P) (
    sum(c in 1..C) (x[p,c]) <= Supply[p]
  ) /\ 
  forall(c in 1..C) (
    sum(p in 1..P) (x[p,c]) = Demand[c]
  );

% Objective
solve minimize
  sum(p in 1..P, c in 1..C) (x[p,c] * TransmissionCosts[p,c]);