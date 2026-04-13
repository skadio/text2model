% Facility location / capacitated distribution with fixed opening costs
% All data embedded as requested.

int: NC = 8; % potential distribution centers
int: NS = 8; % retail stores

set of int: C = 1..NC;
set of int: S = 1..NS;

array[C] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[C,S] of int: ship_cost = array2d(C, S, [
  3,3,5,4,3,5,2,4,
  2,4,5,1,4,2,5,4,
  1,1,3,3,2,4,4,3,
  4,4,1,3,5,3,5,1,
  2,4,1,4,2,2,1,2,
  5,2,4,4,4,4,5,3,
  1,4,2,4,2,2,4,5,
  2,2,4,2,2,4,4,1
]);

array[S] of int: demand = [695, 737, 452, 616, 587, 779, 892, 440];

array[C] of int: capacity = [1980, 814, 864, 1320, 1952, 1447, 1886, 1962];

int: total_demand = sum(s in S)(demand[s]);

array[C] of var bool: open;

% Flow (units shipped) from center c to store s
array[C,S] of var 0..total_demand: x;

% Demand satisfaction
constraint forall(s in S)(
  sum(c in C)(x[c,s]) = demand[s]
);

% Capacity only if opened
constraint forall(c in C)(
  sum(s in S)(x[c,s]) <= capacity[c] * bool2int(open[c])
);

var int: total_open_cost = sum(c in C)(open_cost[c] * bool2int(open[c]));
var int: total_ship_cost = sum(c in C, s in S)(ship_cost[c,s] * x[c,s]);
var int: total_cost = total_open_cost + total_ship_cost;

solve minimize total_cost;

output [
  "Total cost = ", show(total_cost), "\n",
  "Open cost  = ", show(total_open_cost), "\n",
  "Ship cost  = ", show(total_ship_cost), "\n\n",
  "Opened centers: ", show([c | c in C where fix(bool2int(open[c])) = 1]), "\n",
  "Shipments x[c,s] (rows centers, cols stores):\n",
  concat([ concat([ show(x[c,s]) ++ if s < NS then "\t" else "\n" endif | s in S]) | c in C ])
];