% Parameters (with values embedded)
int: M = 6; % distribution centers
int: N = 8; % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[Centers, Stores] of int: transCost =
  [| 2, 3, 3, 3, 5, 4, 3, 5
   | 2, 4, 2, 4, 5, 1, 4, 2
   | 5, 4, 1, 1, 3, 3, 2, 4
   | 4, 3, 4, 4, 1, 3, 5, 3
   | 5, 1, 2, 4, 1, 4, 2, 2
   | 1, 2, 5, 2, 4, 4, 4, 4 |];

array[Stores] of int: demand = [908, 434, 605, 480, 961, 787, 401, 789];

array[Centers] of int: capacity = [1365, 1929, 1502, 1201, 1529, 961];

int: totalDemand = sum(Stores)(demand[j]);
int: maxCap = max(capacity);

% Variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..maxCap: ship; % shipped units from center i to store j

% Constraints
constraint
  forall(j in Stores) (
    sum(i in Centers)(ship[i,j]) = demand[j]
  );

constraint
  forall(i in Centers) (
    sum(j in Stores)(ship[i,j]) <= capacity[i] * bool2int(open[i])
  );

constraint
  forall(i in Centers, j in Stores) (
    ship[i,j] <= demand[j] * bool2int(open[i])
  );

% Objective
var int: totalCost =
  sum(i in Centers)(openCost[i] * bool2int(open[i])) +
  sum(i in Centers, j in Stores)(transCost[i,j] * ship[i,j]);

solve minimize totalCost;