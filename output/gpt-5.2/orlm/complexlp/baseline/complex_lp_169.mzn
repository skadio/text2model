% Facility location / capacitated distribution problem (all data embedded)

int: F = 6; % potential distribution centers
int: S = 8; % retail stores

set of int: FAC = 1..F;
set of int: STO = 1..S;

array[FAC] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000];

% Transportation cost per unit from each center to each store
array[FAC, STO] of int: ship_cost =
[
  % Stores:   1  2  3  4  5  6  7  8
              2, 3, 4, 5, 6, 7, 8, 5,  % Center 1
              2, 4, 6, 8, 6, 4, 2, 2,  % Center 2
              5, 4, 3, 2, 1, 2, 3, 4,  % Center 3
              4, 3, 2, 1, 2, 3, 4, 3,  % Center 4
              5, 1, 2, 3, 4, 5, 3, 2,  % Center 5
              1, 2, 3, 4, 5, 6, 5, 4   % Center 6
];

array[STO] of int: demand = [908, 434, 605, 480, 961, 787, 401, 789];
array[FAC] of int: capacity = [1365, 1929, 1502, 1201, 1529, 961];

% Decision variables
array[FAC] of var bool: open;
array[FAC, STO] of var int: x; % units shipped from center i to store j

% Bounds on shipments
constraint forall(i in FAC, j in STO) (x[i,j] >= 0 /\ x[i,j] <= demand[j]);

% Meet each store's demand exactly
constraint forall(j in STO) (
  sum(i in FAC)(x[i,j]) = demand[j]
);

% Capacity only available if center is open
constraint forall(i in FAC) (
  sum(j in STO)(x[i,j]) <= capacity[i] * bool2int(open[i])
);

var int: total_open_cost = sum(i in FAC)(open_cost[i] * bool2int(open[i]));
var int: total_ship_cost = sum(i in FAC, j in STO)(ship_cost[i,j] * x[i,j]);
var int: total_cost = total_open_cost + total_ship_cost;

solve minimize total_cost;

output [
  "Total cost = ", show(total_cost), "\n",
  "Open cost  = ", show(total_open_cost), "\n",
  "Ship cost  = ", show(total_ship_cost), "\n\n",
  "Open centers (1=open,0=closed):\n",
  concat([ "  Center " ++ show(i) ++ ": " ++ show(bool2int(open[i])) ++ "\n" | i in FAC ]),
  "\nShipments x[i,j] (rows centers, cols stores):\n",
  concat([ concat([ show(x[i,j]) ++ if j==S then "\n" else "\t" endif | j in STO ]) | i in FAC ])
];