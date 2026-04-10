% Facility location / distribution planning
% Data is embedded (no .dzn needed)

int: num_centers = 7;
int: num_stores  = 6;

set of int: CENTERS = 1..num_centers;
set of int: STORES  = 1..num_stores;

array[CENTERS] of int: open_cost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[CENTERS, STORES] of int: ship_cost =
  [| 3, 3, 5, 4, 3, 5
   | 2, 4, 2, 4, 5, 1
   | 4, 2, 5, 4, 1, 1
   | 3, 3, 2, 4, 4, 3
   | 4, 4, 1, 3, 5, 3
   | 5, 1, 2, 4, 1, 4
   | 2, 2, 1, 2, 5, 2 |];

array[STORES] of int: demand =
  [739, 491, 766, 854, 827, 908];

array[CENTERS] of int: capacity =
  [1575, 834, 1005, 1904, 1825, 1821, 1365];

int: total_demand = sum(s in STORES)(demand[s]);

% Use smaller per-arc upper bounds to avoid huge domains (helps prevent timeouts)
array[CENTERS, STORES] of int: ub_flow =
  array2d(CENTERS, STORES, [ min(capacity[c], demand[s]) | c in CENTERS, s in STORES ]);

% Decision variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var int: flow;

% Domain constraints for flow using tight bounds
constraint forall(c in CENTERS, s in STORES)(
  flow[c,s] >= 0 /\ flow[c,s] <= ub_flow[c,s]
);

% Demand satisfaction
constraint forall(s in STORES)(
  sum(c in CENTERS)(flow[c,s]) = demand[s]
);

% Capacity only if open
constraint forall(c in CENTERS)(
  sum(s in STORES)(flow[c,s]) <= capacity[c] * bool2int(open[c])
);

% Objective: minimize opening + shipping
var int: total_cost =
    sum(c in CENTERS)(open_cost[c] * bool2int(open[c]))
  + sum(c in CENTERS, s in STORES)(ship_cost[c,s] * flow[c,s]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([bool2int(open[c]) | c in CENTERS]), "\n",
  "flow=\n"
] ++
[
  if s = 1 then "" else "" endif ++
  concat([ show(flow[c,s]) ++ if c = num_centers then "\n" else " " endif | c in CENTERS ])
  | s in STORES
];