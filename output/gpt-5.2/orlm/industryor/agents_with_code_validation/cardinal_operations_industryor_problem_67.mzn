% Parameters
int: n_yards = 2;                      % number of coal yards
int: n_areas = 3;                      % number of residential areas

set of int: YARDS = 1..n_yards;        % yard index set
set of int: AREAS = 1..n_areas;        % area index set

array[YARDS] of int: min_supply = [80, 100];   % minimum monthly supply from each yard (tons)
array[AREAS] of int: demand = [55, 75, 50];    % monthly demand for each area (tons)

array[YARDS, AREAS] of int: dist_km =          % distance from yard to area (km)
  [| 10,  5,  6
   |  4,  8, 15 |];

% Variables
% ship_tons[y,a] = tons shipped from yard y to area a
% Upper bound can be total demand (55+75+50=180); given 205 is safe and consistent.
array[YARDS, AREAS] of var 0..205: ship_tons;

% Constraints

% --- Demand satisfaction: each residential area receives exactly its required tons ---
constraint
  forall(a in AREAS) (
    sum(y in YARDS)(ship_tons[y, a]) = demand[a]
  );

% --- Minimum supply from each coal yard: each yard ships at least its required minimum ---
constraint
  forall(y in YARDS) (
    sum(a in AREAS)(ship_tons[y, a]) >= min_supply[y]
  );

% --- Optional tightening: no yard can ship more than total demand (redundant but helps propagation) ---
constraint
  forall(y in YARDS) (
    sum(a in AREAS)(ship_tons[y, a]) <= sum(a in AREAS)(demand[a])
  );

% Objective
solve minimize
  sum(y in YARDS, a in AREAS) (ship_tons[y, a] * dist_km[y, a]);