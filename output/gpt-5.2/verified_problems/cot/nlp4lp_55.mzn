% Parameters
int: P;
int: C;

set of int: PLANTS = 1..P;
set of int: CITIES = 1..C;

array[PLANTS] of int: Supply;
array[CITIES] of int: Demand;
array[PLANTS, CITIES] of int: TransmissionCosts;

% Variables
array[PLANTS, CITIES] of var 0..max(Supply): Flow;

% Constraints
constraint
  forall(p in PLANTS)(
    sum(c in CITIES)(Flow[p,c]) <= Supply[p]
  );

constraint
  forall(c in CITIES)(
    sum(p in PLANTS)(Flow[p,c]) = Demand[c]
  );

% Objective
solve minimize sum(p in PLANTS, c in CITIES)(TransmissionCosts[p,c] * Flow[p,c]);