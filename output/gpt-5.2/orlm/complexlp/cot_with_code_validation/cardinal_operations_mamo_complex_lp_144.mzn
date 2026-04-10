% Facility location / distribution planning
% Data embedded as requested

int: F = 4; % distribution centers
int: S = 8; % stores

set of int: FC = 1..F;
set of int: ST = 1..S;

array[FC] of int: open_cost = [151000, 192000, 114000, 171000];

array[FC, ST] of int: trans_cost =
 [| 5, 5, 2, 3, 3, 3, 5, 4
  | 3, 5, 2, 4, 2, 4, 5, 1
  | 4, 2, 5, 4, 1, 1, 3, 3
  | 2, 4, 4, 3, 4, 4, 1, 3 |];

array[ST] of int: demand = [884, 420, 566, 673, 787, 1000, 715, 413];
array[FC] of int: capacity = [1041, 1576, 1364, 1697];

int: max_ship_ij = max(j in ST)(demand[j]);

% Decision variables
array[FC] of var bool: open;
array[FC, ST] of var 0..max_ship_ij: ship;

% Cost variables (computed)
var int: total_open_cost = sum(i in FC)(open_cost[i] * bool2int(open[i]));
var int: total_trans_cost = sum(i in FC, j in ST)(trans_cost[i,j] * ship[i,j]);
var int: total_cost = total_open_cost + total_trans_cost;

% Constraints: satisfy all store demand
constraint forall(j in ST) (
  sum(i in FC)(ship[i,j]) = demand[j]
);

% Shipments only from open centers and within capacity
constraint forall(i in FC) (
  sum(j in ST)(ship[i,j]) <= capacity[i] * bool2int(open[i])
);

% Objective type is satisfaction; compute total_cost but do not optimize
solve satisfy;

output [
  "open = ", show(open), "\n",
  "ship = ", show(ship), "\n",
  "total_open_cost = ", show(total_open_cost), "\n",
  "total_trans_cost = ", show(total_trans_cost), "\n",
  "total_cost = ", show(total_cost), "\n"
];