include "globals.mzn";

%----------------------------
% Data (embedded)
%----------------------------
int: M = 6; % distribution centers
int: N = 5; % retail stores

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000];
array[DC] of int: cap      = [1400,   1115,   813,   1041,   1576,   1364];
array[ST] of int: demand   = [884, 420, 566, 673, 787];

array[DC, ST] of int: transCost =
  [| 2, 3, 3, 3, 5
   | 4, 3, 5, 2, 4
   | 2, 4, 5, 1, 4
   | 2, 5, 4, 1, 1
   | 3, 3, 2, 4, 4
   | 3, 4, 4, 1, 3 |];

%----------------------------
% Decision variables
%----------------------------
array[DC] of var bool: open;
array[DC, ST] of var 0..max(cap): ship;

%----------------------------
% Constraints
%----------------------------
constraint
  forall(s in ST) (
    sum(d in DC)(ship[d,s]) = demand[s]
  );

constraint
  forall(d in DC) (
    sum(s in ST)(ship[d,s]) <= cap[d] * bool2int(open[d])
  );

%----------------------------
% Objective (minimize)
%----------------------------
var int: totalCost =
  sum(d in DC)(openCost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(transCost[d,s] * ship[d,s]);

solve :: int_search([ship[d,s] | d in DC, s in ST] ++ [bool2int(open[d]) | d in DC],
                    first_fail, indomain_min, complete)
minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[d]) | d in DC]), "\n",
  "ship=\n"
] ++ [
  concat([ if s = 1 then "" else " " endif ++ show(ship[d,s]) | s in ST ]) ++ "\n"
  | d in DC
];