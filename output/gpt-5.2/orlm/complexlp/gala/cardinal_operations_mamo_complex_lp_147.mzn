include "globals.mzn";

%----------------------------
% Data (embedded as requested)
%----------------------------
int: M = 8;   % distribution centers
int: N = 9;   % retail stores

set of int: Centers = 1..M;
set of int: Stores  = 1..N;

array[Centers] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000
];

array[Centers, Stores] of int: shipCost = [
  % s1 s2 s3 s4 s5 s6 s7 s8 s9
  |  3, 3, 5, 4, 3, 5, 2, 4, 2  % center 1
  |  4, 5, 1, 4, 2, 5, 4, 1, 1  % center 2
  |  3, 3, 2, 4, 4, 3, 4, 4, 1  % center 3
  |  3, 5, 3, 5, 1, 2, 4, 1, 4  % center 4
  |  2, 2, 1, 2, 5, 2, 4, 4, 4  % center 5
  |  4, 5, 3, 1, 4, 2, 4, 2, 2  % center 6
  |  4, 5, 2, 2, 4, 2, 2, 4, 4  % center 7
  |  1, 5, 5, 2, 5, 2, 1, 4, 4  % center 8
];

array[Stores] of int: demand = [779, 892, 440, 556, 414, 464, 920, 743, 528];

array[Centers] of int: capacity = [1447, 1886, 1962, 1392, 1191, 1218, 1088, 1178];

%----------------------------
% Decision variables
%----------------------------
array[Centers] of var 0..1: open;                      % 1 if center is opened
array[Centers, Stores] of var int: x;                  % shipped units center->store

% Upper bounds for shipments (tighten domains)
constraint forall(i in Centers, j in Stores)(
  x[i,j] >= 0 /\ x[i,j] <= demand[j]
);

%----------------------------
% Constraints
%----------------------------

% Meet every store's demand exactly
constraint forall(j in Stores)(
  sum(i in Centers)(x[i,j]) = demand[j]
);

% Do not exceed each center's capacity; if closed, cannot ship
constraint forall(i in Centers)(
  sum(j in Stores)(x[i,j]) <= capacity[i] * open[i]
);

%----------------------------
% Objective
%----------------------------
var int: totalOpenCost = sum(i in Centers)(openCost[i] * open[i]);
var int: totalShipCost = sum(i in Centers, j in Stores)(shipCost[i,j] * x[i,j]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

%----------------------------
% Output
%----------------------------
output [
  "Total cost = ", show(totalCost), "\n",
  "  Opening cost = ", show(totalOpenCost), "\n",
  "  Shipping cost = ", show(totalShipCost), "\n\n",
  "Open centers (1=open): ", show(open), "\n\n",
  "Shipments x[center,store]:\n",
  concat([ "Center " ++ show(i) ++ ": " ++ show([ x[i,j] | j in Stores ]) ++ "\n"
           | i in Centers ])
];