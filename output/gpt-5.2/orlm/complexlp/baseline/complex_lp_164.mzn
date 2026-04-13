% Facility Location / Capacitated Distribution with fixed opening costs
% All data embedded as requested.

int: NCenters = 7;
int: NStores  = 9;

set of int: C = 1..NCenters;
set of int: S = 1..NStores;

array[C] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000
];

array[C] of int: capacity = [
  814, 864, 1320, 1952, 1447, 1886, 1962
];

array[S] of int: demand = [
  695, 737, 452, 616, 587, 779, 892, 440, 556
];

array[C, S] of int: transCost =
  [| 3, 3, 5, 4, 3, 5, 2, 4, 2
   | 4, 5, 1, 4, 2, 5, 4, 1, 1
   | 3, 3, 2, 4, 4, 3, 4, 4, 1
   | 3, 5, 3, 5, 1, 2, 4, 1, 4
   | 2, 2, 1, 2, 5, 2, 4, 4, 4
   | 4, 5, 3, 1, 4, 2, 4, 2, 2
   | 4, 5, 2, 2, 4, 2, 2, 4, 4 |];

% Decision variables
array[C] of var bool: open;
array[C, S] of var 0..max(demand): ship; % units shipped from center c to store s

% Each store demand must be met exactly
constraint
  forall(s in S)(
    sum(c in C)(ship[c,s]) = demand[s]
  );

% Capacity constraints (only if opened)
constraint
  forall(c in C)(
    sum(s in S)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Objective: opening + transportation
var int: totalOpenCost = sum(c in C)(openCost[c] * bool2int(open[c]));
var int: totalTransCost = sum(c in C, s in S)(transCost[c,s] * ship[c,s]);
var int: totalCost = totalOpenCost + totalTransCost;

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "totalOpenCost=", show(totalOpenCost), "\n",
  "totalTransCost=", show(totalTransCost), "\n\n",
  "Open centers: ", show([c | c in C where fix(open[c]) = 1]), "\n\n",
  "Shipments (center->store: units):\n"
] ++
[
  if fix(ship[c,s]) > 0 then
    "  C" ++ show(c) ++ "->S" ++ show(s) ++ ": " ++ show(fix(ship[c,s])) ++ "\n"
  else "" endif
  | c in C, s in S
];