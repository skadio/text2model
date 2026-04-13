% Facility Location + Transportation (Capacitated)
% Data embedded as requested.

include "int_search.mzn";

%----------------------------
% Parameters
%----------------------------
int: num_centers = 6;
int: num_stores  = 8;

set of int: CENTERS = 1..num_centers;
set of int: STORES  = 1..num_stores;

array[CENTERS] of int: open_cost =
  [151000, 192000, 114000, 171000, 160000, 120000];

array[CENTERS, STORES] of int: ship_cost =
  [| 2, 3, 3, 4, 3, 4, 2, 5
   | 2, 4, 4, 2, 5, 5, 4, 2
   | 5, 4, 4, 4, 2, 4, 2, 4
   | 4, 3, 4, 3, 4, 3, 5, 3
   | 5, 1, 2, 4, 2, 4, 2, 2
   | 1, 2, 2, 2, 2, 4, 4, 4 |];

array[STORES] of int: demand =
  [908, 434, 605, 480, 961, 787, 401, 789];

array[CENTERS] of int: capacity =
  [1365, 1929, 1502, 1201, 1529, 961];

int: total_demand = sum(s in STORES)(demand[s]);

% Big-M bound for each arc (tighter than total_demand)
array[CENTERS, STORES] of int: max_flow =
  array2d(CENTERS, STORES, [ min(capacity[c], demand[s]) | c in CENTERS, s in STORES ]);

%----------------------------
% Decision variables
%----------------------------
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..total_demand: flow;

var 0..(sum(c in CENTERS)(open_cost[c]) + sum(c in CENTERS, s in STORES)(ship_cost[c,s] * max_flow[c,s])): total_cost;

%----------------------------
% Constraints
%----------------------------
% Arc bounds and linking to opening decision (if closed => no flow)
constraint
  forall(c in CENTERS, s in STORES) (
    flow[c,s] <= max_flow[c,s] * bool2int(open[c])
  );

% Capacity at each center
constraint
  forall(c in CENTERS) (
    sum(s in STORES)(flow[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Demand satisfaction
constraint
  forall(s in STORES) (
    sum(c in CENTERS)(flow[c,s]) = demand[s]
  );

% Cost
constraint
  total_cost =
    sum(c in CENTERS)(open_cost[c] * bool2int(open[c])) +
    sum(c in CENTERS, s in STORES)(ship_cost[c,s] * flow[c,s]);

%----------------------------
% Search (avoid timeout by guiding the solver)
%----------------------------
solve
  :: int_search([bool2int(open[c]) | c in CENTERS], first_fail, indomain_min, complete)
  :: int_search([flow[c,s] | c in CENTERS, s in STORES], first_fail, indomain_min, complete)
  minimize total_cost;

%----------------------------
% Output
%----------------------------
output [
  "total_cost=", show(total_cost), "\n",
  "open=", show(open), "\n",
  "flow=\n",
  concat([ concat([ show(flow[c,s]) ++ if s == num_stores then "\n" else " " endif
                  | s in STORES ])
         | c in CENTERS ])
];