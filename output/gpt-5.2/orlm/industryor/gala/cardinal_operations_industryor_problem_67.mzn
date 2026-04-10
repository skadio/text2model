% Coal transportation (2 supply nodes -> 3 demand nodes) minimize ton-kilometers

% ----- Data (embedded) -----
set of int: YARDS = 1..2;     % 1=A, 2=B
set of int: AREAS = 1..3;     % 1,2,3 residential areas

array[YARDS] of int: supply = [80, 100];           % tons available per month
array[AREAS] of int: demand = [55, 75, 50];        % tons required per month

array[YARDS, AREAS] of int: dist = array2d(YARDS, AREAS,
  [ 10, 5, 6,        % from A to areas 1..3
    4,  8, 15 ]      % from B to areas 1..3
);

% ----- Decision variables -----
array[YARDS, AREAS] of var 0..max(supply): x;  % x[y,a] tons shipped from yard y to area a

% ----- Constraints -----
% Do not exceed each yard's available supply
constraint forall(y in YARDS)(
  sum(a in AREAS)(x[y,a]) <= supply[y]
);

% Meet each area's demand exactly
constraint forall(a in AREAS)(
  sum(y in YARDS)(x[y,a]) = demand[a]
);

% ----- Objective -----
var int: total_ton_km = sum(y in YARDS, a in AREAS)(x[y,a] * dist[y,a]);
solve minimize total_ton_km;

% ----- Output -----
output [
  "Total ton-km = ", show(total_ton_km), "\n",
  "Shipments (tons) x[yard,area]:\n",
  "A -> [", show(x[1,1]), ", ", show(x[1,2]), ", ", show(x[1,3]), "]\n",
  "B -> [", show(x[2,1]), ", ", show(x[2,2]), ", ", show(x[2,3]), "]\n"
];