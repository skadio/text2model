% Parameters
int: num_yards = 2;                  % coal yards: A,B
int: num_areas = 3;                  % residential areas: 1..3

set of int: YARDS = 1..num_yards;
set of int: AREAS = 1..num_areas;

array[YARDS] of int: supply_min = [80, 100];           % minimum monthly receipts at yards A,B (tons)
array[AREAS] of int: demand = [55, 75, 50];            % monthly demand in areas 1..3 (tons)

array[YARDS, AREAS] of int: dist_km =                  % distances (km) from yards to areas
  [| 10,  5,  6,
     4,  8, 15 |];

int: total_demand = sum(a in AREAS)(demand[a]);        % total tons that must be shipped


% Variables
array[YARDS, AREAS] of var 0..total_demand: ship;      % tons shipped from yard y to area a
array[YARDS] of var 0..total_demand: yard_total_ship;  % total tons shipped out of each yard
var 0..(total_demand * max(y in YARDS, a in AREAS)(dist_km[y,a])): total_ton_km; % objective value


% Constraints

% --- Area demand satisfaction: each residential area must receive exactly its demand ---
constraint
  forall(a in AREAS) (
    sum(y in YARDS)(ship[y, a]) = demand[a]
  );

% --- Yard outbound totals definition: link yard_total_ship to shipments ---
constraint
  forall(y in YARDS) (
    yard_total_ship[y] = sum(a in AREAS)(ship[y, a])
  );

% --- Minimum monthly receipts/shipping requirement at each yard ---
% Each coal yard must handle (ship out) at least its minimum required tons.
constraint
  forall(y in YARDS) (
    yard_total_ship[y] >= supply_min[y]
  );

% --- Total shipped equals total demand (redundant but strengthens the model) ---
constraint
  sum(y in YARDS)(yard_total_ship[y]) = total_demand;

% --- Total ton-kilometers calculation: define total_ton_km from shipments and distances ---
constraint
  total_ton_km =
    sum(y in YARDS, a in AREAS)(
      ship[y, a] * dist_km[y, a]
    );


% Objective
solve minimize total_ton_km;