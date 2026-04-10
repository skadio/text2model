include "globals.mzn";

%-----------------------
% Data (embedded)
%-----------------------
int: M = 4; % distribution centers
int: N = 4; % retail outlets

set of int: CENTERS = 1..M;
set of int: OUTLETS  = 1..N;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000];

array[CENTERS, OUTLETS] of int: transCost =
  [| 5, 5, 2, 3
   | 3, 3, 5, 4
   | 3, 5, 2, 4
   | 2, 4, 5, 1 |];

array[OUTLETS] of int: demand = [859, 713, 421, 652];
array[CENTERS] of int: capacity = [1547, 1656, 1274, 1882];

int: totalDemand = sum(j in OUTLETS)(demand[j]);
int: maxShipPerArc = max(demand); % tighter than 1882, improves solving speed

%-----------------------
% Decision variables
%-----------------------
array[CENTERS] of var bool: open;
array[CENTERS, OUTLETS] of var 0..maxShipPerArc: ship;

var int: totalCost =
  sum(i in CENTERS)(openCost[i] * bool2int(open[i])) +
  sum(i in CENTERS, j in OUTLETS)(transCost[i,j] * ship[i,j]);

%-----------------------
% Constraints
%-----------------------
constraint
  forall(j in OUTLETS) (
    sum(i in CENTERS)(ship[i,j]) = demand[j]
  );

constraint
  forall(i in CENTERS) (
    sum(j in OUTLETS)(ship[i,j]) <= capacity[i] * bool2int(open[i])
  );

% Symmetry-breaking: center 1 has highest capacity; a safe, mild rule to speed up search
constraint open[1] >= open[2];
constraint open[1] >= open[3];
constraint open[1] >= open[4];

% Strengthening: enough capacity must be opened to cover total demand
constraint sum(i in CENTERS)(capacity[i] * bool2int(open[i])) >= totalDemand;

%-----------------------
% Objective
%-----------------------
solve minimize totalCost;

%-----------------------
% Output
%-----------------------
output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n",
  "ship=\n",
  concat([ concat([ if j=1 then "" else " " endif ++ show(ship[i,j]) | j in OUTLETS ]) ++ "\n"
          | i in CENTERS ])
];