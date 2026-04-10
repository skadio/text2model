include "globals.mzn";

%------------------------------------------------------------
% Capacitated Facility Location / Transportation with fixed opening costs
% Data embedded directly from the problem statement.
%
% NOTE: The problem statement does not provide the full 9x8 matrix of
% per-unit transportation costs nor the 8 store demands nor the 9 center
% capacities (only ranges and a couple example entries). This model
% therefore cannot be instantiated to a numeric optimum without those
% missing numbers.
%
% To run this model, you must fill in:
%  - demand[1..8]
%  - capacity[1..9]
%  - shipCost[1..9,1..8]
% with the exact values from your source data.
%------------------------------------------------------------

int: m = 9; % potential distribution centers
int: n = 8; % retail stores

set of int: C = 1..m;
set of int: S = 1..n;

array[C] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000
];

% ---------------------------
% MISSING in the description:
% Fill these with exact values.
% ---------------------------

% demand[s] = required units at store s
array[S] of int: demand = [
  % TODO: replace with the 8 store demands (units), e.g. 414..920
  0, 0, 0, 0, 0, 0, 0, 0
];

% capacity[c] = max units that center c can supply if opened
array[C] of int: capacity = [
  % TODO: replace with the 9 center capacities (units), e.g. 1030..1962
  0, 0, 0, 0, 0, 0, 0, 0, 0
];

% shipCost[c,s] = cost per unit from center c to store s
array[C, S] of int: shipCost = array2d(C, S, [
  % TODO: replace with the full 9x8 matrix (72 integers) row-major:
  % center 1 to stores 1..8, then center 2 to stores 1..8, etc.
  % Example mentioned: cost(1,1)=3; cost(2,2)=5;
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0
]);

% Decision variables
array[C] of var 0..1: open;                 % 1 if center c is opened
array[C, S] of var int: ship;               % units shipped from c to s
constraint forall(c in C, s in S)(ship[c,s] >= 0);

% Demand satisfaction: each store's demand must be met exactly
constraint forall(s in S)(
  sum(c in C)(ship[c,s]) = demand[s]
);

% Capacity: total shipped from an open center cannot exceed its capacity;
% if not open, must ship 0.
constraint forall(c in C)(
  sum(s in S)(ship[c,s]) <= capacity[c] * open[c]
);

% Objective: minimize opening + transportation costs
var int: totalOpenCost = sum(c in C)(openCost[c] * open[c]);
var int: totalShipCost = sum(c in C, s in S)(shipCost[c,s] * ship[c,s]);
var int: totalCost = totalOpenCost + totalShipCost;

solve minimize totalCost;

output [
  "TotalCost = ", show(totalCost), "\n",
  "OpenCost  = ", show(totalOpenCost), "\n",
  "ShipCost  = ", show(totalShipCost), "\n",
  "Open      = ", show(open), "\n",
  "Ship      = ", show(ship), "\n"
];