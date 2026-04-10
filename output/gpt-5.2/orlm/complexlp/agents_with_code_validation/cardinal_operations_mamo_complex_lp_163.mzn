% Facility location / transportation with opening decisions
% All data embedded as requested.

int: nDC = 6;
int: nStore = 9;

set of int: DC = 1..nDC;
set of int: Store = 1..nStore;

array[DC] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000];

% Unit transport costs (rows = DCs, cols = Stores)
array[DC, Store] of int: transCost =
  array2d(DC, Store, [
    % DC1 (S1..S9)
    2, 3, 3, 4, 5, 6, 7, 2, 2,
    % DC2
    4, 2, 5, 2, 3, 4, 5, 6, 4,
    % DC3
    1, 1, 2, 3, 4, 5, 6, 3, 4,
    % DC4
    4, 1, 3, 2, 4, 3, 5, 2, 4,
    % DC5
    1, 4, 2, 4, 3, 2, 4, 3, 4,
    % DC6
    4, 4, 4, 4, 4, 4, 4, 4, 4
  ]);

array[Store] of int: demand =
  [401, 524, 713, 401, 683, 501, 955, 498, 366];

array[DC] of int: capacity =
  [1795, 1455, 1135, 1405, 1225, 1095];

% Decision variables
array[DC] of var bool: open;
array[DC, Store] of var 0..max(capacity): ship;

% Constraints

% Demand satisfaction
constraint forall(s in Store) (
  sum(d in DC)(ship[d, s]) = demand[s]
);

% Capacity and "closed => no shipping"
constraint forall(d in DC) (
  sum(s in Store)(ship[d, s]) <= capacity[d] * bool2int(open[d])
);

% Arc-level tightening (optional but fine)
constraint forall(d in DC, s in Store) (
  ship[d, s] <= capacity[d] * bool2int(open[d])
);

% Feasibility strengthening: opened capacity must cover total demand
constraint
  sum(d in DC)(capacity[d] * bool2int(open[d])) >= sum(s in Store)(demand[s]);

% Objective: opening + transport
solve minimize
  sum(d in DC)(openCost[d] * bool2int(open[d]))
+ sum(d in DC, s in Store)(transCost[d, s] * ship[d, s]);