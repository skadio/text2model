% Parameters (with values embedded)
int: M = 7; % distribution centers
int: N = 9; % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[Centers, Stores] of int: transCost =
[| 3, 3, 5, 4, 3, 5, 2, 4, 2
 | 4, 5, 1, 4, 2, 5, 4, 1, 1
 | 3, 3, 2, 4, 4, 3, 4, 4, 1
 | 3, 5, 3, 5, 1, 2, 4, 1, 4
 | 2, 2, 1, 2, 5, 2, 4, 4, 4
 | 4, 5, 3, 1, 4, 2, 4, 2, 2
 | 4, 5, 2, 2, 4, 2, 2, 4, 4 |];

array[Stores] of int: demand = [695, 737, 452, 616, 587, 779, 892, 440, 556];
array[Centers] of int: capacity = [814, 864, 1320, 1952, 1447, 1886, 1962];

int: totalDemand = sum(Stores)(demand[s]);

% Variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..totalDemand: ship;

% Constraints
constraint
  forall(s in Stores)(
    sum(c in Centers)(ship[c,s]) = demand[s]
  );

constraint
  forall(c in Centers)(
    sum(s in Stores)(ship[c,s]) <= capacity[c]
  );

constraint
  forall(c in Centers)(
    sum(s in Stores)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Objective
var int: totalCost =
  sum(c in Centers)(openCost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(transCost[c,s] * ship[c,s]);

solve minimize totalCost;