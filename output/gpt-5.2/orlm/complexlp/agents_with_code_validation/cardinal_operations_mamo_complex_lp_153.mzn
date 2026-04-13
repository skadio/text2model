% GlobalSupply Inc. - Facility location / transportation with fixed opening costs
% Data is embedded (no .dzn).

int: nCenters = 4;
int: nStores  = 6;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000];

array[CENTERS, STORES] of int: transCost =
  [| 5, 5, 2, 3, 3, 3
   | 5, 4, 3, 5, 2, 4
   | 2, 4, 5, 1, 4, 2
   | 5, 4, 1, 1, 3, 3 |];

array[STORES] of int: demand = [910, 875, 589, 962, 966, 643];

array[CENTERS] of int: capacity = [1631, 1954, 1446, 820];

int: totalDemand = sum(s in STORES)(demand[s]);

% Decision variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var int: ship; % bounded below via constraints

% Bounds on shipments (tighter than 0..totalDemand and helps solve faster)
constraint forall(c in CENTERS, s in STORES)(
  ship[c,s] >= 0 /\ ship[c,s] <= demand[s]
);

% Meet each store's demand exactly
constraint forall(s in STORES)(
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

% Capacity only if opened
constraint forall(c in CENTERS)(
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Objective: fixed opening + variable transport
var int: totalCost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c]))
  + sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);

solve :: int_search([ship[c,s] | c in CENTERS, s in STORES] ++ [bool2int(open[c]) | c in CENTERS],
                    first_fail, indomain_min, complete)
minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "open = ", show([open[c] | c in CENTERS]), "\n",
  "ship =\n",
  concat([ concat([ "  " ++ show(ship[c,s]) ++ if s==nStores then "\n" else "" endif
                  | s in STORES ])
         | c in CENTERS ])
];