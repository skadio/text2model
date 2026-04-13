% Transportation problem: minimize ton-kilometers

int: m = 2; % coal yards
int: n = 3; % residential areas

set of int: YARDS = 1..m;
set of int: AREAS = 1..n;

% Minimum monthly receipts (treated as available supply to distribute)
array[YARDS] of int: supply = [80, 100];

% Monthly demands
array[AREAS] of int: demand = [55, 75, 50];

% Distances (km) from each yard to each area
array[YARDS, AREAS] of int: dist =
  array2d(YARDS, AREAS,
    [ 10,  5,  6,   % Yard A to areas 1..3
       4,  8, 15    % Yard B to areas 1..3
    ]);

% Decision variables: tons shipped from yard i to area j
array[YARDS, AREAS] of var int: x;
constraint forall(i in YARDS, j in AREAS) (x[i,j] >= 0);

% Meet each area's demand exactly
constraint forall(j in AREAS) (
  sum(i in YARDS)(x[i,j]) = demand[j]
);

% Do not exceed each yard's available supply (can have leftover)
constraint forall(i in YARDS) (
  sum(j in AREAS)(x[i,j]) <= supply[i]
);

% Objective: minimize ton-kilometers
var int: total_ton_km = sum(i in YARDS, j in AREAS)(x[i,j] * dist[i,j]);
solve minimize total_ton_km;

output [
  "Total ton-km = ", show(total_ton_km), "\n",
  "Shipments (tons):\n",
  "A -> areas: ", show([x[1,j] | j in AREAS]), "\n",
  "B -> areas: ", show([x[2,j] | j in AREAS]), "\n"
];