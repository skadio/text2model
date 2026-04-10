% Parameters (with values embedded)
int: M = 5; % potential distribution centers
int: N = 5; % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[Centers, Stores] of int: transCost =
 [| 5, 2, 3, 3, 3
  | 5, 4, 3, 5, 2
  | 4, 2, 4, 5, 1
  | 4, 2, 5, 4, 1
  | 1, 3, 3, 2, 4 |];

array[Stores] of int: demand = [589, 962, 966, 643, 904];
array[Centers] of int: capacity = [1954, 1446, 820, 1640, 966];

int: totalDemand = sum(Stores)(demand[s]);
int: maxCap = max(c in Centers)(capacity[c]);

% Variables
array[Centers] of var 0..1: open; % 1 if distribution center is opened
array[Centers, Stores] of var 0..maxCap: ship; % units shipped from center c to store s
var int: total_cost;

% Constraints
constraint
  forall(s in Stores)(
    sum(c in Centers)(ship[c,s]) = demand[s]
  );

constraint
  forall(c in Centers)(
    sum(s in Stores)(ship[c,s]) <= capacity[c] * open[c]
  );

constraint
  total_cost =
    sum(c in Centers)(openCost[c] * open[c]) +
    sum(c in Centers, s in Stores)(transCost[c,s] * ship[c,s]);

% Objective
solve minimize total_cost;