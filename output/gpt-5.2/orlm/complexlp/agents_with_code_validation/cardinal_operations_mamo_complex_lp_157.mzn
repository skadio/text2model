% Facility location / transportation problem
% Data embedded as requested

int: nCenters = 6;
int: nStores  = 5;

set of int: Centers = 1..nCenters;
set of int: Stores  = 1..nStores;

array[Centers] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000];

array[Centers, Stores] of int: transCost =
  [| 2, 3, 3, 3, 5
   | 4, 3, 5, 2, 4
   | 2, 4, 5, 1, 4
   | 2, 5, 4, 1, 1
   | 3, 3, 2, 4, 4
   | 3, 4, 4, 1, 3 |];

array[Stores] of int: demand =
  [884, 420, 566, 673, 787];

array[Centers] of int: capacity =
  [1400, 1115, 813, 1041, 1576, 1364];

% Tight bounds for faster solving (avoid huge default domains)
array[Centers, Stores] of int: maxShip =
  array2d(Centers, Stores, [ min(capacity[c], demand[s]) | c in Centers, s in Stores ]);

% Decision variables
array[Centers] of var bool: open;
array[Centers, Stores] of var int: ship;

% Domains for ship variables
constraint
  forall(c in Centers, s in Stores) (
    ship[c,s] >= 0 /\ ship[c,s] <= maxShip[c,s]
  );

% Meet each store's demand exactly
constraint
  forall(s in Stores) (
    sum(c in Centers)(ship[c, s]) = demand[s]
  );

% Capacity only if opened
constraint
  forall(c in Centers) (
    sum(s in Stores)(ship[c, s]) <= capacity[c] * bool2int(open[c])
  );

var int: total_cost =
  sum(c in Centers)(openCost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(transCost[c, s] * ship[c, s]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([ bool2int(open[c]) | c in Centers ]), "\n",
  "ship=\n"
] ++
[
  "  center " ++ show(c) ++ ": " ++ show([ ship[c,s] | s in Stores ]) ++ "\n"
  | c in Centers
];