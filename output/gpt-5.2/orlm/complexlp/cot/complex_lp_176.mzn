% Parameters (with values embedded)
int: N = 7; % potential distribution centers
int: M = 5; % retail stores

set of int: Centers = 1..N;
set of int: Stores  = 1..M;

array[Centers] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];
array[Centers] of int: capacity  = [1697, 891, 1755, 1308, 1575, 834, 1005];
array[Stores]  of int: demand    = [715, 413, 641, 745, 964];

array[Centers, Stores] of int: ship_cost = 
[| 3, 3, 5, 4, 3
 | 5, 2, 4, 2, 4
 | 5, 1, 4, 2, 5
 | 4, 1, 1, 3, 3
 | 2, 4, 4, 3, 4
 | 4, 1, 3, 5, 3
 | 5, 1, 2, 4, 1 |];

int: total_demand = sum(s in Stores)(demand[s]);

% Variables
array[Centers] of var 0..1: open;
array[Centers, Stores] of var 0..total_demand: x; % shipped units from center c to store s

% Constraints
constraint
  forall(s in Stores)(
    sum(c in Centers)(x[c,s]) = demand[s]
  );

constraint
  forall(c in Centers)(
    sum(s in Stores)(x[c,s]) <= capacity[c] * open[c]
  );

% Objective
var int: total_cost =
  sum(c in Centers)(open_cost[c] * open[c]) +
  sum(c in Centers, s in Stores)(ship_cost[c,s] * x[c,s]);

solve minimize total_cost;