% Facility Location / Transportation with capacities
% Data embedded as required

int: NCenters = 4;
int: NStores  = 8;

set of int: C = 1..NCenters;
set of int: S = 1..NStores;

array[C] of int: open_cost = [151000, 192000, 114000, 171000];

array[C,S] of int: trans_cost =
[| 5, 5, 2, 3, 3, 3, 5, 4
 | 3, 5, 2, 4, 2, 4, 5, 1
 | 4, 2, 5, 4, 1, 1, 3, 3
 | 2, 4, 4, 3, 4, 4, 1, 3 |];

array[S] of int: demand   = [884, 420, 566, 673, 787, 1000, 715, 413];
array[C] of int: capacity = [1041, 1576, 1364, 1697];

int: total_demand = sum(s in S)(demand[s]);
int: max_tc = max([ trans_cost[c,s] | c in C, s in S ]);

% Decision variables
array[C] of var bool: open;
array[C,S] of var 0..total_demand: ship;

% Constraints: meet each store demand exactly
constraint forall(s in S)(
  sum(c in C)(ship[c,s]) = demand[s]
);

% Capacity only if center is open
constraint forall(c in C)(
  sum(s in S)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Objective: minimize opening + transport costs
var int: total_cost =
  sum(c in C)(open_cost[c] * bool2int(open[c])) +
  sum(c in C, s in S)(trans_cost[c,s] * ship[c,s]);

solve :: int_search([ship[c,s] | c in C, s in S], first_fail, indomain_min, complete)
     minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([bool2int(open[c]) | c in C]), "\n"
];