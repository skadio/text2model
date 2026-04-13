include "globals.mzn";

%----------------------------
% Data (embedded)
%----------------------------
int: C = 4; % distribution centers
int: O = 4; % outlets

array[1..C] of int: openCost = [151000, 192000, 114000, 171000];

array[1..C, 1..O] of int: transCost =
  [| 5, 5, 2, 3
   | 3, 3, 5, 4
   | 3, 5, 2, 4
   | 2, 4, 5, 1 |];

array[1..O] of int: demand = [859, 713, 421, 652];
array[1..C] of int: capacity = [1547, 1656, 1274, 1882];

int: totalDemand = sum(o in 1..O)(demand[o]);

%----------------------------
% Decision variables
%----------------------------
array[1..C] of var 0..1: open; % 1 if center opened

array[1..C, 1..O] of var 0..totalDemand: ship; % units shipped from center c to outlet o

%----------------------------
% Constraints
%----------------------------

% Meet each outlet's demand exactly
constraint forall(o in 1..O) (
  sum(c in 1..C)(ship[c,o]) = demand[o]
);

% Do not exceed each center's capacity; if not opened, ship nothing
constraint forall(c in 1..C) (
  sum(o in 1..O)(ship[c,o]) <= capacity[c] * open[c]
);

%----------------------------
% Objective
%----------------------------
var int: totalOpenCost = sum(c in 1..C)(openCost[c] * open[c]);
var int: totalTransCost = sum(c in 1..C, o in 1..O)(transCost[c,o] * ship[c,o]);
var int: totalCost = totalOpenCost + totalTransCost;

solve minimize totalCost;

%----------------------------
% Output
%----------------------------
output [
  "Total cost = ", show(totalCost), "\n",
  "  Opening cost = ", show(totalOpenCost), "\n",
  "  Transport cost = ", show(totalTransCost), "\n\n",
  "Open centers (1..", show(C), ") = ", show(open), "\n\n",
  "Shipment matrix ship[c,o] (c=1..", show(C), ", o=1..", show(O), "):\n",
  concat([ concat([ "  ", show(ship[c,o]) ] ++ [ if o=O then "\n" else "" endif | o in 1..O ])
           | c in 1..C ])
];