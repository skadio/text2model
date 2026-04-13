include "globals.mzn";

% ---------- Data (embedded) ----------
int: C = 4;  % distribution centers
int: S = 8;  % stores

array[1..C] of int: openCost = [151000, 192000, 114000, 171000];

array[1..C, 1..S] of int: shipCost = array2d(1..C, 1..S, [
   5, 5, 2, 3, 3, 3, 5, 4,   % center 1 -> stores 1..8
   3, 5, 2, 4, 2, 4, 5, 1,   % center 2
   4, 2, 5, 4, 1, 1, 3, 3,   % center 3
   2, 4, 4, 3, 4, 4, 1, 3    % center 4
]);

array[1..S] of int: demand = [884, 420, 566, 673, 787, 1000, 715, 413];
array[1..C] of int: capacity = [1041, 1576, 1364, 1697];

% ---------- Decision variables ----------
% open[c] = 1 iff center c is opened
array[1..C] of var 0..1: open;

% x[c,s] = units shipped from center c to store s
array[1..C, 1..S] of var 0..max(demand): x;

% ---------- Constraints ----------
% Demand satisfaction: each store's demand must be met exactly
constraint forall(s in 1..S) (
  sum(c in 1..C)(x[c,s]) = demand[s]
);

% Capacity: shipments out of a center cannot exceed capacity, and must be 0 if not opened
constraint forall(c in 1..C) (
  sum(s in 1..S)(x[c,s]) <= capacity[c] * open[c]
);

% ---------- Objective ----------
var int: totalOpenCost = sum(c in 1..C)(openCost[c] * open[c]);
var int: totalShipCost = sum(c in 1..C, s in 1..S)(shipCost[c,s] * x[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

% ---------- Output ----------
output [
  "TotalCost = ", show(totalCost), "\n",
  "OpenCost  = ", show(totalOpenCost), "\n",
  "ShipCost  = ", show(totalShipCost), "\n",
  "Open      = ", show(open), "\n",
  "Shipments (rows=centers, cols=stores):\n",
  show([ [ x[c,s] | s in 1..S ] | c in 1..C ]), "\n"
];