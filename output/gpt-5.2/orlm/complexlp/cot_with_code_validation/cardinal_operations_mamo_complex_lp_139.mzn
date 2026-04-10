% SupplyLink facility location + transportation

% Parameters
int: NCenters = 5;
int: NStores  = 5;

set of int: Centers = 1..NCenters;
set of int: Stores  = 1..NStores;

array[Centers] of int: open_cost = [151000, 192000, 114000, 171000, 160000];
array[Centers] of int: capacity  = [1954, 1446, 820, 1640, 966];
array[Stores]  of int: demand    = [589, 962, 966, 643, 904];

array[Centers, Stores] of int: ship_cost =
  array2d(Centers, Stores, [
    5, 2, 3, 3, 3,
    5, 4, 3, 5, 2,
    4, 2, 4, 5, 1,
    4, 2, 5, 4, 1,
    1, 3, 3, 2, 4
  ]);

int: total_demand = sum(s in Stores)(demand[s]);

% Variables
array[Centers] of var 0..1: open;
array[Centers, Stores] of var 0..total_demand: ship;

var int: total_cost;

% Constraints: satisfy each store's demand
constraint forall(s in Stores)(
  sum(c in Centers)(ship[c, s]) = demand[s]
);

% Constraints: shipments only from open centers, within capacity
constraint forall(c in Centers)(
  sum(s in Stores)(ship[c, s]) <= capacity[c] * open[c]
);

% Total cost
constraint total_cost =
  sum(c in Centers)(open_cost[c] * open[c]) +
  sum(c in Centers, s in Stores)(ship_cost[c, s] * ship[c, s]);

% Objective
solve minimize total_cost;