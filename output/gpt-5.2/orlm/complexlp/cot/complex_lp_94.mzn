% Parameters (with values embedded)
int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[|  0, 94, 34, 87
 | 94,  0, 62, 87
 | 34, 62,  0, 97
 | 87, 87, 97,  0
 |];

% Variables
array[CITIES] of var CITIES: succ;   % succ[i] = next city after i in the tour
array[CITIES] of var CITIES: pos;    % position index to eliminate subtours (MTZ)

var int: total_cost;

% Constraints
constraint forall(i in CITIES)(succ[i] != i);
constraint all_different(succ);

% MTZ subtour elimination (fix city 1 as start)
constraint pos[1] = 1;
constraint forall(i in 2..n)(pos[i] >= 2 /\ pos[i] <= n);
constraint forall(i in 2..n, j in 2..n where i != j)(
  pos[i] - pos[j] + n * (if succ[i] = j then 1 else 0 endif) <= n - 1
);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;