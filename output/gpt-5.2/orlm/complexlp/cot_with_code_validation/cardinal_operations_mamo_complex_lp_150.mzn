% Facility location / transportation problem (embedded data)

% Parameters
int: M = 7; % distribution centers
int: N = 9; % retail stores

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: open_cost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000
];

% Capacities (units) and demands (units)
array[DC] of int: capacity = [1962, 1500, 1200, 1400, 1100, 900, 814];
array[ST] of int: demand   = [892, 780, 650, 600, 560, 520, 500, 470, 440];

int: total_demand = sum(s in ST)(demand[s]);

% Transportation cost per unit (dollars), values in 1..5
% FIX: provide a proper 2D array [DC,ST]
array[DC, ST] of int: transp_cost = array2d(DC, ST, [
  % dc1
  2, 3, 4, 2, 5, 3, 1, 4, 2,
  % dc2
  3, 2, 5, 3, 4, 2, 2, 5, 3,
  % dc3
  1, 2, 3, 2, 4, 3, 2, 4, 1,
  % dc4
  4, 3, 2, 3, 2, 4, 3, 1, 5,
  % dc5
  2, 4, 3, 5, 1, 2, 4, 3, 2,
  % dc6
  3, 1, 2, 4, 3, 5, 2, 2, 4,
  % dc7
  5, 2, 1, 3, 2, 4, 5, 3, 1
]);

% Decision variables
array[DC] of var bool: open;
array[DC, ST] of var 0..total_demand: ship;

var int: total_cost;

% Constraints: meet all store demands
constraint forall(s in ST)(
  sum(d in DC)(ship[d, s]) = demand[s]
);

% Capacity only if a DC is open
constraint forall(d in DC)(
  sum(s in ST)(ship[d, s]) <= capacity[d] * bool2int(open[d])
);

% Objective expression
constraint total_cost =
  sum(d in DC)(open_cost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(transp_cost[d, s] * ship[d, s]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([bool2int(open[d]) | d in DC]), "\n"
];