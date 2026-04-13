% Facility location / distribution planning (all data embedded)

int: num_centers = 6;
int: num_stores  = 4;

set of int: CENTERS = 1..num_centers;
set of int: STORES  = 1..num_stores;

array[CENTERS] of int: open_cost =
  [151000, 192000, 114000, 171000, 160000, 120000];

array[CENTERS, STORES] of int: ship_cost =
  [| 2, 3, 3, 3
   | 5, 4, 3, 5
   | 2, 4, 2, 4
   | 5, 1, 4, 2
   | 5, 4, 1, 1
   | 3, 3, 2, 4 |];

array[STORES] of int: demand =
  [589, 962, 966, 643];

array[CENTERS] of int: capacity =
  [1631, 1954, 1446, 820, 1640, 966];

int: total_demand = sum(s in STORES)(demand[s]);

% Decision variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..total_demand: flow;

% Total cost (bounded to help the solver)
int: max_open_cost = sum(c in CENTERS)(open_cost[c]);
int: max_ship_cost = max([ship_cost[c,s] | c in CENTERS, s in STORES]);
var 0..(max_open_cost + total_demand * max_ship_cost): total_cost;

% Constraints
constraint forall(s in STORES)(
  sum(c in CENTERS)(flow[c,s]) = demand[s]
);

constraint forall(c in CENTERS)(
  sum(s in STORES)(flow[c,s]) <= capacity[c] * bool2int(open[c])
);

constraint total_cost =
  sum(c in CENTERS)(open_cost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(ship_cost[c,s] * flow[c,s]);

% Objective type requested: maximization.
% To keep the model meaningful for a cost objective, maximize the negative total cost
% (equivalent to minimizing total_cost).
solve maximize (-total_cost);

output [show(-total_cost)];