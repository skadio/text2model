% Facility Location / Capacitated Distribution Center Problem
% All data embedded as requested.

int: F = 7; % potential distribution centers
int: S = 5; % stores

set of int: FAC = 1..F;
set of int: STO = 1..S;

array[FAC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];
array[FAC] of int: cap      = [  1697,    891,   1755,   1308,   1575,    834,   1005];
array[STO] of int: demand   = [   715,    413,    641,    745,    964];

array[FAC, STO] of int: shipCost =
[
  % s1 s2 s3 s4 s5
  |  3, 3, 5, 4, 3  % center 1
  |, 5, 2, 4, 2, 4  % center 2
  |, 5, 1, 4, 2, 5  % center 3
  |, 4, 1, 1, 3, 3  % center 4
  |, 2, 4, 4, 3, 4  % center 5
  |, 4, 1, 3, 5, 3  % center 6
  |, 5, 1, 2, 4, 1  % center 7
];

% Decision variables
array[FAC] of var bool: open;
array[FAC, STO] of var 0..max(demand): x; % shipped units from center f to store s

% Demand satisfaction
constraint forall(s in STO) (
  sum(f in FAC)(x[f,s]) = demand[s]
);

% Capacity with opening decision
constraint forall(f in FAC) (
  sum(s in STO)(x[f,s]) <= cap[f] * bool2int(open[f])
);

% Objective: opening + transportation
var int: totalCost =
  sum(f in FAC)(openCost[f] * bool2int(open[f])) +
  sum(f in FAC, s in STO)(shipCost[f,s] * x[f,s]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open centers (1=open,0=closed): ", show([bool2int(open[f]) | f in FAC]), "\n",
  "Shipments x[f,s] (rows=centers, cols=stores):\n"
] ++
[
  concat([ if s=1 then "" else " " endif ++ show(x[f,s]) | s in STO]) ++ "\n"
  | f in FAC
];