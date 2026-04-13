% Facility location + transportation (capacitated) with embedded data

include "globals.mzn";

%----------------------------
% Parameters
%----------------------------
int: M = 5; % distribution centers
int: N = 9; % retail stores

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[DC, ST] of int: transCost =
  [| 5, 2, 3, 3, 3, 5, 4, 3, 5
   | 2, 4, 2, 4, 5, 1, 4, 2, 5
   | 4, 1, 1, 3, 3, 2, 4, 4, 3
   | 4, 4, 1, 3, 5, 3, 5, 1, 2
   | 4, 1, 4, 2, 2, 1, 2, 5, 2 |];

array[ST] of int: demand = [739, 491, 766, 854, 827, 908, 434, 605, 480];
array[DC] of int: capacity = [1825, 1821, 1365, 1929, 1502];

int: totalDemand = sum(s in ST)(demand[s]);

%----------------------------
% Decision variables
%----------------------------
array[DC] of var bool: open;

% ship[d,s] = units shipped from distribution center d to store s
array[DC, ST] of var 0..totalDemand: ship;

%----------------------------
% Constraints
%----------------------------
% Meet each store's demand exactly
constraint
  forall(s in ST)(
    sum(d in DC)(ship[d,s]) = demand[s]
  );

% Respect capacity if center is open; force shipments to 0 if closed
constraint
  forall(d in DC)(
    sum(s in ST)(ship[d,s]) <= capacity[d] * bool2int(open[d])
  );

%----------------------------
% Objective
%----------------------------
var int: totalCost =
    sum(d in DC)(openCost[d] * bool2int(open[d])) +
    sum(d in DC, s in ST)(transCost[d,s] * ship[d,s]);

solve :: int_search([bool2int(open[d]) | d in DC] ++ [ship[d,s] | d in DC, s in ST],
                    first_fail, indomain_min, complete)
minimize totalCost;

%----------------------------
% Output
%----------------------------
output [
  "totalCost = ", show(totalCost), "\n",
  "open = ", show([bool2int(open[d]) | d in DC]), "\n",
  "ship =\n",
  concat([ concat([ show(ship[d,s]) ++ if s==N then "\n" else "\t" endif | s in ST]) | d in DC ])
];