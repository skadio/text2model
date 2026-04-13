% Power transmission / transportation problem

% Parameters
int: P;
int: C;

array[1..P] of int: Supply;
array[1..C] of int: Demand;
array[1..P, 1..C] of int: TransmissionCosts;

% Variables: electricity sent from plant p to city c
array[1..P, 1..C] of var 0..max(Supply): Flow;

% Constraints: plant capacities
constraint
  forall(p in 1..P) (
    sum(c in 1..C)(Flow[p,c]) <= Supply[p]
  );

% Constraints: city demands must be met
constraint
  forall(c in 1..C) (
    sum(p in 1..P)(Flow[p,c]) >= Demand[c]
  );

% Objective: minimize total transmission cost
solve minimize
  sum(p in 1..P, c in 1..C)(TransmissionCosts[p,c] * Flow[p,c]);