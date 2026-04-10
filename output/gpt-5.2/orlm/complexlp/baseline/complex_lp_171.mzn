% Facility location + transportation (capacitated) with embedded data

int: F = 6; % potential distribution centers
int: S = 7; % stores

set of int: FAC = 1..F;
set of int: STO = 1..S;

array[FAC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];

array[FAC, STO] of int: transCost =
[
  % s1 s2 s3 s4 s5 s6 s7
  |  2, 3, 3, 3, 5, 4, 3  % center 1
  |  5, 2, 4, 2, 4, 5, 1  % center 2
  |  4, 2, 5, 4, 1, 1, 3  % center 3
  |  3, 2, 4, 4, 3, 4, 4  % center 4
  |  1, 3, 5, 3, 5, 1, 2  % center 5
  |  4, 1, 4, 2, 2, 1, 2  % center 6
];

array[STO] of int: demand = [964, 739, 491, 766, 854, 827, 908];
array[FAC] of int: cap    = [1575, 834, 1005, 1904, 1825, 1821];

int: totalDemand = sum(STO)(demand[s]);

array[FAC] of var bool: open;

% Flow shipped from facility f to store s
array[FAC, STO] of var 0..totalDemand: x;

% Demand satisfaction (exactly meet)
constraint forall(s in STO) (
  sum(f in FAC)(x[f,s]) = demand[s]
);

% Capacity and linking to opening decision
constraint forall(f in FAC) (
  sum(s in STO)(x[f,s]) <= cap[f] * bool2int(open[f])
);

var int: totalCost =
  sum(f in FAC)(openCost[f] * bool2int(open[f])) +
  sum(f in FAC, s in STO)(transCost[f,s] * x[f,s]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open centers: ", show([ bool2int(open[f]) | f in FAC ]), "\n",
  "Flows x[f,s]:\n"
] ++
[
  "Center " ++ show(f) ++ ": " ++ show([ x[f,s] | s in STO ]) ++ "\n"
  | f in FAC
];