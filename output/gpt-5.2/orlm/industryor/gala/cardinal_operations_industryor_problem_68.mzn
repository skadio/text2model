include "globals.mzn";

% Cutting stock / trim loss minimization
% Demand: 90 pieces of length 3, 60 pieces of length 4
% Stock length: 10

int: stockLen = 10;
set of int: L = {3,4};
array[L] of int: demand = [90,60];

% Enumerate all feasible cutting patterns for one 10m stock bar:
% pattern p is (a3[p], a4[p]) with 3*a3 + 4*a4 <= 10
int: maxA3 = stockLen div 3;
int: maxA4 = stockLen div 4;

array[1..(maxA3+1)*(maxA4+1)] of int: candA3 =
  [ a3 | a3 in 0..maxA3, a4 in 0..maxA4 ];
array[1..(maxA3+1)*(maxA4+1)] of int: candA4 =
  [ a4 | a3 in 0..maxA3, a4 in 0..maxA4 ];

array[1..(maxA3+1)*(maxA4+1)] of bool: feasible =
  [ 3*candA3[i] + 4*candA4[i] <= stockLen | i in index_set(candA3) ];

int: P = sum(i in index_set(feasible))( bool2int(feasible[i]) );

array[1..P] of int: a3 = [ candA3[i] | i in index_set(candA3) where feasible[i] ];
array[1..P] of int: a4 = [ candA4[i] | i in index_set(candA4) where feasible[i] ];
array[1..P] of int: wastePerBar = [ stockLen - (3*a3[p] + 4*a4[p]) | p in 1..P ];

% Decision: number of 10m bars cut with pattern p
int: maxBars = demand[3] + demand[4]; % safe upper bound
array[1..P] of var 0..maxBars: x;

% Meet demand (can overproduce; will be discouraged by waste minimization)
constraint sum(p in 1..P)(a3[p] * x[p]) >= demand[3];
constraint sum(p in 1..P)(a4[p] * x[p]) >= demand[4];

% Objective: minimize total waste length
var 0..stockLen*maxBars: totalWaste = sum(p in 1..P)(wastePerBar[p] * x[p]);

solve minimize totalWaste;

output [
  "Patterns (a3,a4,waste):\n",
  concat([ "p=" ++ show(p) ++ ": (" ++ show(a3[p]) ++ "," ++ show(a4[p]) ++
           "), waste=" ++ show(wastePerBar[p]) ++ "\n"
         | p in 1..P ]),
  "\nUse (x[p]):\n",
  concat([ if fix(x[p]) > 0 then "x[" ++ show(p) ++ "]=" ++ show(x[p]) ++ "\n" else "" endif
         | p in 1..P ]),
  "\nTotal waste = ", show(totalWaste), "\n",
  "Produced 3m = ", show(sum(p in 1..P)(a3[p]*x[p])), " (demand ", show(demand[3]), ")\n",
  "Produced 4m = ", show(sum(p in 1..P)(a4[p]*x[p])), " (demand ", show(demand[4]), ")\n",
  "Total 10m bars used = ", show(sum(p in 1..P)(x[p])), "\n"
];