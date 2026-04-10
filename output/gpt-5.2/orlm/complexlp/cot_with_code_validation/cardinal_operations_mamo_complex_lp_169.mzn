% Parameters
int: M = 6; % distribution centers
int: N = 8; % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000];
array[Centers] of int: capacity  = [1365,   1929,   1502,   1201,   1529,   961];

array[Stores] of int: demand = [908, 434, 605, 480, 961, 787, 401, 789];

array[Centers, Stores] of int: trans_cost =
[| 2, 3, 4, 5, 2, 3, 4, 5
 | 2, 4, 3, 5, 4, 3, 5, 2
 | 5, 4, 3, 2, 5, 4, 3, 4
 | 4, 3, 2, 5, 4, 3, 2, 3
 | 5, 1, 2, 3, 4, 5, 1, 2
 | 1, 2, 3, 4, 1, 2, 3, 4
 |];

int: total_demand = sum(s in Stores)(demand[s]);
int: max_cost = max([open_cost[i] | i in Centers]) + max([trans_cost[i,s] | i in Centers, s in Stores]) * total_demand;

% Variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..total_demand: ship;

var 0..max_cost: total_cost;

% Constraints
constraint
  forall(s in Stores)(
    sum(i in Centers)(ship[i,s]) = demand[s]
  );

constraint
  forall(i in Centers)(
    sum(s in Stores)(ship[i,s]) <= capacity[i] * bool2int(open[i])
  );

constraint
  total_cost =
    sum(i in Centers)(open_cost[i] * bool2int(open[i])) +
    sum(i in Centers, s in Stores)(trans_cost[i,s] * ship[i,s]);

% Objective
solve minimize total_cost;