% Facility location with flows (data embedded)

%-------------------- Parameters --------------------
int: nCenters = 5;
int: nStores  = 6;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =
  [151000, 192000, 114000, 171000, 160000];

array[CENTERS, STORES] of int: transCost =
  array2d(CENTERS, STORES,
    [
      5, 2, 3, 3, 3, 5,
      4, 3, 5, 2, 4, 2,
      4, 5, 1, 4, 2, 5,
      4, 1, 1, 3, 3, 2,
      4, 4, 3, 4, 4, 1
    ]
  );

array[STORES] of int: demand =
  [530, 884, 420, 566, 673, 787];

array[CENTERS] of int: capacity =
  [1400, 1115, 813, 1041, 1576];

% Tight per-(i,j) upper bounds reduce search and avoid timeouts
array[CENTERS, STORES] of int: maxShip =
  array2d(CENTERS, STORES,
    [ min(capacity[i], demand[j]) | i in CENTERS, j in STORES ]);

%-------------------- Variables --------------------
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var int: ship;

% Domain bounds for ship variables
constraint forall(i in CENTERS, j in STORES)(
  ship[i,j] >= 0 /\ ship[i,j] <= maxShip[i,j]
);

%-------------------- Constraints --------------------
% Meet each store demand exactly
constraint forall(j in STORES)(
  sum(i in CENTERS)(ship[i,j]) = demand[j]
);

% Respect capacity if opened (otherwise 0)
constraint forall(i in CENTERS)(
  sum(j in STORES)(ship[i,j]) <= capacity[i] * bool2int(open[i])
);

% Optional symmetry-breaking: if a higher-index center is open, all lower are open
% (can speed up without changing optimal cost if costs/capacities similar; comment out if undesired)
% constraint forall(i in 2..nCenters)(bool2int(open[i-1]) >= bool2int(open[i]));

%-------------------- Objective / Solve --------------------
% Objective type requested: satisfaction (find any feasible plan)
solve satisfy;

%-------------------- Output --------------------
output [
  "open = ", show(open), "\n",
  "ship =\n",
  concat([ concat([ show(ship[i,j]) ++ if j==nStores then "\n" else "\t" endif
                  | j in STORES ])
         | i in CENTERS ])
];