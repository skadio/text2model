include "globals.mzn";

%----------------------------
% Data (embedded as requested)
%----------------------------
int: nCenters = 4;
int: nStores  = 8;

array[1..nCenters] of int: openCost = [151000, 192000, 114000, 171000];

array[1..nCenters, 1..nStores] of int: transCost =
[
  % stores:   1  2  3  4  5  6  7  8
            |5, 5, 2, 3, 3, 3, 5, 4|,   % center 1
            |3, 5, 2, 4, 2, 4, 5, 1|,   % center 2
            |4, 2, 5, 4, 1, 1, 3, 3|,   % center 3
            |2, 4, 4, 3, 4, 4, 1, 3|    % center 4
];

array[1..nStores] of int: demand = [884, 420, 566, 673, 787, 1000, 715, 413];
array[1..nCenters] of int: capacity = [1041, 1576, 1364, 1697];

int: totalDemand = sum(demand);

%----------------------------
% Decision variables
%----------------------------
array[1..nCenters] of var 0..1: open;  % 1 if center is opened

% flow[c,s] = units shipped from center c to store s
array[1..nCenters, 1..nStores] of var 0..totalDemand: flow;

%----------------------------
% Constraints
%----------------------------

% Each store demand must be met exactly
constraint forall(s in 1..nStores)(
  sum(c in 1..nCenters)(flow[c,s]) = demand[s]
);

% Each center cannot exceed capacity, and if not open then ships nothing
constraint forall(c in 1..nCenters)(
  sum(s in 1..nStores)(flow[c,s]) <= capacity[c] * open[c]
);

%----------------------------
% Objective
%----------------------------
var int: openingCostTotal =
  sum(c in 1..nCenters)(openCost[c] * open[c]);

var int: transportCostTotal =
  sum(c in 1..nCenters, s in 1..nStores)(transCost[c,s] * flow[c,s]);

var int: totalCost = openingCostTotal + transportCostTotal;

solve minimize totalCost;

%----------------------------
% Output
%----------------------------
output [
  "TotalCost = ", show(totalCost), "\n",
  "OpeningCost = ", show(openingCostTotal), "\n",
  "TransportCost = ", show(transportCostTotal), "\n",
  "OpenCenters = ", show(open), "\n",
  "Flow (rows=center 1..4, cols=store 1..8):\n",
  show([ [ flow[c,s] | s in 1..nStores ] | c in 1..nCenters ]), "\n"
];