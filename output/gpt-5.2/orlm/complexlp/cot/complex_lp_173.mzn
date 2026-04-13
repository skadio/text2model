% Parameters (with values embedded)
int: num_centers = 4;
int: num_stores  = 8;

set of int: CENTERS = 1..num_centers;
set of int: STORES  = 1..num_stores;

array[CENTERS] of int: open_cost = [151000, 192000, 114000, 171000];

array[CENTERS, STORES] of int: ship_cost =
 [| 5, 5, 2, 3, 3, 3, 5, 4
  | 3, 5, 2, 4, 2, 4, 5, 1
  | 4, 2, 5, 4, 1, 1, 3, 3
  | 2, 4, 4, 3, 4, 4, 1, 3 |];

array[STORES] of int: demand = [884, 420, 566, 673, 787, 1000, 715, 413];
array[CENTERS] of int: capacity = [1041, 1576, 1364, 1697];

int: total_demand = sum(s in STORES)(demand[s]);
int: max_ship = total_demand;

% Variables
array[CENTERS] of var 0..1: open;
array[CENTERS, STORES] of var 0..max_ship: ship;

% Constraints
constraint
  forall(s in STORES)(
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

constraint
  forall(c in CENTERS)(
    sum(s in STORES)(ship[c,s]) <= capacity[c] * open[c]
  );

% Objective
var int: total_cost =
  sum(c in CENTERS)(open_cost[c] * open[c]) +
  sum(c in CENTERS, s in STORES)(ship_cost[c,s] * ship[c,s]);

solve minimize total_cost;