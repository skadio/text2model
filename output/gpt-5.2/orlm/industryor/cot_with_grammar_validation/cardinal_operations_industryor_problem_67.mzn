% Parameters
int: Y = 2; % coal yards
int: R = 3; % residential areas

set of int: YARDS = 1..Y;
set of int: AREAS = 1..R;

array[YARDS] of int: supply_min = [80, 100];
array[AREAS] of int: demand = [55, 75, 50];

array[YARDS, AREAS] of int: dist_km =
  [| 10,  5,  6
   |  4,  8, 15 |];

int: total_demand = sum(a in AREAS)(demand[a]);
int: total_supply_min = sum(y in YARDS)(supply_min[y]);

% Variables
array[YARDS, AREAS] of var 0..total_demand: x; % tons shipped from yard y to area a

% Constraints
constraint forall(a in AREAS)(
  sum(y in YARDS)(x[y,a]) = demand[a]
);

constraint forall(y in YARDS)(
  sum(a in AREAS)(x[y,a]) >= supply_min[y]
);

% Objective
var 0..(max(dist_km) * total_demand): total_ton_km;
constraint total_ton_km = sum(y in YARDS, a in AREAS)(dist_km[y,a] * x[y,a]);

solve minimize total_ton_km;