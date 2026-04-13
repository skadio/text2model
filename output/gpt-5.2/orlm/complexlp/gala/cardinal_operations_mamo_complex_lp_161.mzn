include "globals.mzn";

%-----------------------------
% Data (embedded as requested)
%-----------------------------
int: C = 5;  % distribution centers
int: S = 7;  % retail stores

array[1..C] of int: openCost = [151000, 192000, 114000, 171000, 160000];

array[1..C, 1..S] of int: shipCost = array2d(1..C, 1..S, [
   5,2,3,3,3,5,4,   % center 1 -> stores 1..7
   3,5,2,4,2,4,5,   % center 2
   1,4,2,5,4,1,1,   % center 3
   3,3,2,4,4,3,4,   % center 4
   4,1,3,5,3,5,1    % center 5
]);

array[1..S] of int: demand = [566, 673, 787, 1000, 715, 413, 641];
array[1..C] of int: capacity = [1576, 1364, 1697, 891, 1755];

int: maxDemand = max(demand);

%-----------------------------
% Decision variables
%-----------------------------
array[1..C] of var 0..1: open;                       % 1 if center is opened
array[1..C, 1..S] of var 0..maxDemand: x;            % units shipped c->s

%-----------------------------
% Constraints
%-----------------------------

% Meet every store's demand exactly
constraint
  forall(s in 1..S)(
    sum(c in 1..C)(x[c,s]) = demand[s]
  );

% Respect each center's capacity (only if opened)
constraint
  forall(c in 1..C)(
    sum(s in 1..S)(x[c,s]) <= capacity[c] * open[c]
  );

%-----------------------------
% Objective: opening + transport
%-----------------------------
var int: totalOpenCost = sum(c in 1..C)(openCost[c] * open[c]);
var int: totalShipCost = sum(c in 1..C, s in 1..S)(shipCost[c,s] * x[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

%-----------------------------
% Output
%-----------------------------
output [
  "Total cost = ", show(totalCost), "\n",
  "Opening cost = ", show(totalOpenCost), "\n",
  "Shipping cost = ", show(totalShipCost), "\n",
  "Open centers (1..", show(C), ") = ", show(open), "\n",
  "Shipments x[c,s] (rows=centers, cols=stores):\n",
  concat([ concat([ if s=1 then "" else " " endif ++ show(x[c,s]) | s in 1..S]) ++ "\n" | c in 1..C ])
];