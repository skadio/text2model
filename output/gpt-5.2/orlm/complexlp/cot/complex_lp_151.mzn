% Parameters (with values embedded)
int: M = 5; % potential distribution centers
int: N = 6; % retail stores

array[1..M] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[1..M, 1..N] of int: transCost =
  [| 5, 2, 3, 3, 3, 5
   | 4, 3, 5, 2, 4, 2
   | 4, 5, 1, 4, 2, 5
   | 4, 1, 1, 3, 3, 2
   | 4, 4, 3, 4, 4, 1 |];

array[1..N] of int: demand = [530, 884, 420, 566, 673, 787];
array[1..M] of int: capacity = [1400, 1115, 813, 1041, 1576];

int: totalDemand = sum(j in 1..N)(demand[j]);

% Variables
array[1..M] of var 0..1: open;                 % 1 if center i is opened
array[1..M, 1..N] of var 0..totalDemand: ship; % units shipped from center i to store j

var int: total_open_cost;
var int: total_transport_cost;
var int: total_cost;

% Constraints
constraint forall(i in 1..M)(
  sum(j in 1..N)(ship[i,j]) <= capacity[i] * open[i]
);

constraint forall(j in 1..N)(
  sum(i in 1..M)(ship[i,j]) = demand[j]
);

constraint total_open_cost = sum(i in 1..M)(openCost[i] * open[i]);
constraint total_transport_cost = sum(i in 1..M, j in 1..N)(transCost[i,j] * ship[i,j]);
constraint total_cost = total_open_cost + total_transport_cost;

% Objective
solve minimize total_cost;

output [
  "Optimal total cost = ", show(total_cost), "\n",
  "  Opening cost      = ", show(total_open_cost), "\n",
  "  Transport cost    = ", show(total_transport_cost), "\n",
  "Opened centers (1=open): ", show(open), "\n"
];