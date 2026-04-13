% Parameters (with values embedded)
int: M = 7; % number of potential distribution centers
int: N = 7; % number of retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];

array[Centers, Stores] of int: shipCost =
[
| 3, 3, 5, 4, 3, 5, 2 |
| 4, 2, 4, 5, 1, 4, 2 |
| 5, 4, 1, 1, 3, 3, 2 |
| 4, 4, 3, 4, 4, 1, 3 |
| 5, 3, 5, 1, 2, 4, 1 |
| 4, 2, 2, 1, 2, 5, 2 |
| 4, 4, 4, 4, 5, 3, 1 |
];

array[Stores] of int: demand = [961, 787, 401, 789, 965, 505, 876];

array[Centers] of int: capacity = [1502, 1201, 1529, 961, 1001, 1795, 1069];

int: totalDemand = sum(s in Stores)(demand[s]);
int: maxShip = totalDemand;

% Variables
array[Centers] of var bool: open;                           % whether a center is opened
array[Centers, Stores] of var 0..maxShip: x;                % shipped units center->store
var 0..intmax: totalCost;

% Constraints
% Demand satisfaction (each store fully supplied)
constraint
  forall(s in Stores) (
    sum(c in Centers)(x[c,s]) = demand[s]
  );

% Capacity constraints (cannot exceed capacity, and must be zero if not open)
constraint
  forall(c in Centers) (
    sum(s in Stores)(x[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Define objective expression
constraint
  totalCost =
    sum(c in Centers)(openCost[c] * bool2int(open[c])) +
    sum(c in Centers, s in Stores)(shipCost[c,s] * x[c,s]);

% Objective
solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Opened centers (1=open): ", show([bool2int(open[c]) | c in Centers]), "\n"
];