% Facility location + shipping (MIP)
% Data embedded as requested.

include "globals.mzn";

int: N = 5; % distribution centers
int: M = 7; % retail stores

set of int: DC = 1..N;
set of int: ST = 1..M;

array[DC] of int: open_cost = [151000, 192000, 114000, 171000, 160000];
array[DC] of int: capacity  = [1576, 1364, 1697, 891, 1755];
array[ST] of int: demand    = [566, 673, 787, 1000, 715, 413, 641];

array[DC, ST] of int: ship_cost =
  [| 5, 2, 3, 3, 3, 5, 4
   | 3, 5, 2, 4, 2, 4, 5
   | 1, 4, 2, 5, 4, 1, 1
   | 3, 3, 2, 4, 4, 3, 4
   | 4, 1, 3, 5, 3, 5, 1 |];

int: total_demand = sum(s in ST)(demand[s]);

% Decision variables
array[DC] of var bool: open;
array[DC, ST] of var 0..total_demand: x; % shipped units

% Demand satisfaction
constraint
  forall(s in ST)(
    sum(d in DC)(x[d,s]) = demand[s]
  );

% Capacity only if opened
constraint
  forall(d in DC)(
    sum(s in ST)(x[d,s]) <= capacity[d] * bool2int(open[d])
  );

% Objective (direct expression; avoids weak/bad bounds on total_cost var)
solve minimize
  sum(d in DC)(open_cost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(ship_cost[d,s] * x[d,s]);

output [
  "total_cost = ",
  show(
    sum(d in DC)(open_cost[d] * bool2int(open[d])) +
    sum(d in DC, s in ST)(ship_cost[d,s] * x[d,s])
  ),
  "\nopen = ", show(open), "\n"
];