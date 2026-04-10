% Facility location / distribution planning
% Data embedded as per problem statement

int: num_centers = 4;
int: num_stores  = 4;

set of int: CENTERS = 1..num_centers;
set of int: STORES  = 1..num_stores;

array[CENTERS] of int: open_cost = [151000, 192000, 114000, 171000];
array[CENTERS] of int: capacity  = [1547, 1656, 1274, 1882];

array[STORES] of int: demand = [859, 713, 421, 652];

array[CENTERS, STORES] of int: ship_cost =
  [| 5, 5, 2, 3
   | 3, 3, 5, 4
   | 3, 5, 2, 4
   | 2, 4, 5, 1 |];

int: total_demand = sum(s in STORES)(demand[s]);

% Decision variables
array[CENTERS] of var bool: open;  % true if center is opened

% Shipments
array[CENTERS, STORES] of var 0..total_demand: ship;

% Capacity constraints (only ship if opened)
constraint
  forall(c in CENTERS)(
    sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Meet each store demand exactly
constraint
  forall(s in STORES)(
    sum(c in CENTERS)(ship[c,s]) = demand[s]
  );

% Objective: minimize opening + transportation cost (directly, no auxiliary total_cost var)
var int: total_cost =
  sum(c in CENTERS)(open_cost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(ship_cost[c,s] * ship[c,s]);

solve :: int_search([ bool2int(open[c]) | c in CENTERS ] ++ [ ship[c,s] | c in CENTERS, s in STORES ],
                    first_fail, indomain_min, complete)
minimize total_cost;

output [
  "Total cost = ", show(total_cost), "\n",
  "Open centers: ", show([bool2int(open[c]) | c in CENTERS]), "\n",
  "Ship matrix (centers x stores):\n",
  concat([ concat([ show(ship[c,s]) ++ if s == num_stores then "\n" else "\t" endif
                  | s in STORES ])
         | c in CENTERS ])
];