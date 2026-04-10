int: W = 6; % warehouses / potential distribution centers
int: S = 4; % stores

set of int: WAREHOUSES = 1..W;
set of int: STORES = 1..S;

array[WAREHOUSES] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[WAREHOUSES, STORES] of int: shipCost =
  [| 2, 3, 3, 3
   | 5, 4, 3, 5
   | 2, 4, 2, 4
   | 5, 1, 4, 2
   | 5, 4, 1, 1
   | 3, 3, 2, 4 |];

array[STORES] of int: demand = [589, 962, 966, 643];

array[WAREHOUSES] of int: capacity = [1631, 1954, 1446, 820, 1640, 966];

array[WAREHOUSES] of var bool: open;
array[WAREHOUSES, STORES] of var int: x; % shipped units

constraint forall(w in WAREHOUSES, s in STORES) (x[w,s] >= 0);

% Meet each store's demand exactly
constraint forall(s in STORES) (
  sum(w in WAREHOUSES)(x[w,s]) = demand[s]
);

% Do not exceed capacity; if not open then ship 0
constraint forall(w in WAREHOUSES) (
  sum(s in STORES)(x[w,s]) <= capacity[w] * bool2int(open[w])
);

var int: totalCost =
  sum(w in WAREHOUSES)(openCost[w] * bool2int(open[w])) +
  sum(w in WAREHOUSES, s in STORES)(shipCost[w,s] * x[w,s]);

solve minimize totalCost;

output [show(totalCost)];