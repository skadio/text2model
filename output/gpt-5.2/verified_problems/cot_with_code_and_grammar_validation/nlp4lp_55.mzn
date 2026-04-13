% Parameters
int: P;
int: C;

set of int: PLANTS = 1..P;
set of int: CITIES = 1..C;

array[PLANTS] of int: Supply;
array[CITIES] of int: Demand;
array[PLANTS, CITIES] of int: TransmissionCosts;

% Variables
int: maxSupply = max(Supply);
array[PLANTS, CITIES] of var 0..maxSupply: Flow;

var int: TotalCost;

% Constraints
constraint
  forall(p in PLANTS)(
    sum(c in CITIES)(Flow[p,c]) <= Supply[p]
  );

constraint
  forall(c in CITIES)(
    sum(p in PLANTS)(Flow[p,c]) = Demand[c]
  );

constraint
  TotalCost = sum(p in PLANTS, c in CITIES)(TransmissionCosts[p,c] * Flow[p,c]);

% Objective
solve minimize TotalCost;