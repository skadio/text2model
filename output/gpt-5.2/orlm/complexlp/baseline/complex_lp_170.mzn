% Facility location + transportation (capacitated) with fixed opening costs
% All data embedded.

int: M = 5;   % potential distribution centers
int: N = 9;   % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [151000, 192000, 114000, 171000, 160000];

% Transportation costs per unit from center i to store j
% NOTE: The problem statement references a full matrix but does not provide it.
% The model below includes a placeholder matrix; replace with the true 5x9 costs
% if/when available.
array[Centers, Stores] of int: transCost =
[
  % s1 s2 s3 s4 s5 s6 s7 s8 s9
    5, 2, 5, 5, 5, 5, 5, 5, 5,   % center 1 (only s1=5, s2=2 given; others placeholder)
    2, 4, 5, 5, 5, 5, 5, 5, 5,   % center 2 (only s1=2, s2=4 given; others placeholder)
    5, 5, 5, 5, 5, 5, 5, 5, 5,   % center 3 placeholder
    5, 5, 5, 5, 5, 5, 5, 5, 5,   % center 4 placeholder
    5, 5, 5, 5, 5, 5, 5, 5, 5    % center 5 placeholder
];

array[Stores] of int: demand = [739, 491, 571, 569, 667, 443, 503, 707, 480];

array[Centers] of int: capacity = [1825, 1821, 1365, 1929, 1502];

% Decision variables
array[Centers] of var bool: open;
array[Centers, Stores] of var int: ship;  % units shipped from center i to store j

% Bounds on shipments
constraint forall(i in Centers, j in Stores) (
  ship[i,j] >= 0 /\ ship[i,j] <= demand[j]
);

% Meet each store's demand exactly
constraint forall(j in Stores) (
  sum(i in Centers)(ship[i,j]) = demand[j]
);

% Respect capacities; shipments only allowed if center is open
constraint forall(i in Centers) (
  sum(j in Stores)(ship[i,j]) <= capacity[i] * bool2int(open[i])
);

% Objective: fixed opening + variable transport
var int: totalCost =
  sum(i in Centers)(openCost[i] * bool2int(open[i]))
+ sum(i in Centers, j in Stores)(transCost[i,j] * ship[i,j]);

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "Open centers: ", show([i | i in Centers where fix(open[i]) = 1]), "\n",
  "Shipments (center x store):\n"
] ++
[
  "Center " ++ show(i) ++ ": " ++ show([ship[i,j] | j in Stores]) ++ "\n"
  | i in Centers
];

% If your solver does not support fix() in output, replace the "Open centers" line with:
% "Open centers flags: " ++ show([bool2int(open[i]) | i in Centers]) ++ "\n"