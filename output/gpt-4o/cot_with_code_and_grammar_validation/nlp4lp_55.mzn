% Parameters
int: P;
int: C;
set of int: PLANTS = 1..P;
set of int: CITIES = 1..C;

array[PLANTS] of int: Supply;
array[CITIES] of int: Demand;
array[PLANTS, CITIES] of int: TransmissionCosts;

% Derived parameter
int: TotalSupply = sum(p in PLANTS)(Supply[p]);

% Variables
array[PLANTS, CITIES] of var 0..TotalSupply: Shipment;

% Constraints
constraint
  forall(p in PLANTS) (
    sum(c in CITIES)(Shipment[p, c]) <= Supply[p]
  );

constraint
  forall(c in CITIES) (
    sum(p in PLANTS)(Shipment[p, c]) == Demand[c]
  );

% Objective
solve minimize
  sum(p in PLANTS, c in CITIES)(TransmissionCosts[p, c] * Shipment[p, c]);