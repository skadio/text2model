% Parameters
int: nYards = 2;
int: nAreas = 3;

set of int: YARDS = 1..nYards;
set of int: AREAS = 1..nAreas;

array[YARDS] of int: supplyMin = [80, 100];
array[AREAS] of int: demand = [55, 75, 50];

array[YARDS, AREAS] of int: distKm =
  [| 10,  5,  6
   |  4,  8, 15 |];

int: totalDemand = sum(a in AREAS)(demand[a]);
int: totalSupplyMin = sum(y in YARDS)(supplyMin[y]);

% Variables
array[YARDS, AREAS] of var 0..totalDemand: x; % tons shipped from yard y to area a

% Constraints
constraint
  forall(a in AREAS)(
    sum(y in YARDS)(x[y,a]) = demand[a]
  );

constraint
  forall(y in YARDS)(
    sum(a in AREAS)(x[y,a]) >= supplyMin[y]
  );

constraint
  totalSupplyMin <= totalDemand; % feasibility condition for minimum supplies

% Objective
solve minimize sum(y in YARDS, a in AREAS)(distKm[y,a] * x[y,a]);