% SupplyChain Solutions - Facility location with transportation
% Data embedded as requested

int: NCenters = 7;
int: NStores  = 6;

set of int: C = 1..NCenters;
set of int: S = 1..NStores;

array[C] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];
array[C] of int: cap      = [1575,    834,    1005,   1904,   1825,   1821,   1365];

array[S] of int: demand   = [739, 491, 766, 854, 827, 908];

array[C, S] of int: transCost = array2d(C, S,
[
  3, 3, 5, 4, 3, 5,
  2, 4, 2, 4, 5, 1,
  4, 2, 5, 4, 1, 1,
  3, 3, 2, 4, 4, 3,
  4, 4, 1, 3, 5, 3,
  5, 1, 2, 4, 1, 4,
  2, 2, 1, 2, 5, 2
]);

int: maxShip = sum(s in S)(demand[s]);

% Variables
array[C] of var bool: open;
array[C, S] of var 0..maxShip: ship;

var int: totalCost =
  sum(c in C)(openCost[c] * bool2int(open[c])) +
  sum(c in C, s in S)(transCost[c,s] * ship[c,s]);

% Constraints
constraint forall(s in S)(
  sum(c in C)(ship[c,s]) = demand[s]
);

constraint forall(c in C)(
  sum(s in S)(ship[c,s]) <= cap[c]
);

constraint forall(c in C, s in S)(
  ship[c,s] <= cap[c] * bool2int(open[c])
);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[c]) | c in C]), "\n"
];