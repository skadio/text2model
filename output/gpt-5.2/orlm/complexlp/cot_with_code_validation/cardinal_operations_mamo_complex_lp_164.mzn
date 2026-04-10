% Facility location / transportation (capacitated) - embedded data

int: M = 7; % distribution centers
int: N = 9; % retail stores

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[DC, ST] of int: trans_cost =
 [| 3, 3, 5, 4, 3, 5, 2, 4, 2
  | 4, 5, 1, 4, 2, 5, 4, 1, 1
  | 3, 3, 2, 4, 4, 3, 4, 4, 1
  | 3, 5, 3, 5, 1, 2, 4, 1, 4
  | 2, 2, 1, 2, 5, 2, 4, 4, 4
  | 4, 5, 3, 1, 4, 2, 4, 2, 2
  | 4, 5, 2, 2, 4, 2, 2, 4, 4 |];

array[ST] of int: demand = [695, 737, 452, 616, 587, 779, 892, 440, 556];
array[DC] of int: capacity = [814, 864, 1320, 1952, 1447, 1886, 1962];

int: total_demand = sum(s in ST)(demand[s]);

% Decision variables
array[DC] of var bool: open;
array[DC, ST] of var 0..total_demand: ship;

% Demand satisfaction
constraint forall(s in ST)(
  sum(d in DC)(ship[d,s]) = demand[s]
);

% Capacity / opening linkage
constraint forall(d in DC)(
  sum(s in ST)(ship[d,s]) <= capacity[d] * bool2int(open[d])
);

% Objective (direct expression to avoid huge-domain bounding issues/timeouts)
var int: total_cost =
  sum(d in DC)(open_cost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(trans_cost[d,s] * ship[d,s]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([bool2int(open[d]) | d in DC]), "\n"
];