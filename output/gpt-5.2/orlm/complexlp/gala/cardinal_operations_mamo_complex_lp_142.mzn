include "globals.mzn";

%------------------------------------------------------------
% Facility location / distribution planning (embedded data)
%------------------------------------------------------------

int: F = 9;   % distribution centers
int: S = 6;   % retail stores

set of int: Centers = 1..F;
set of int: Stores  = 1..S;

array[Centers] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000
];

array[Centers] of int: cap = [
  1615, 1255, 1816, 1095, 1519, 1137, 1678, 1876, 1591
];

array[Stores] of int: demand = [
  876, 801, 955, 561, 601, 669
];

array[Centers, Stores] of int: shipCost = array2d(Centers, Stores, [
  % store1 store2 store3 store4 store5 store6
     3,     5,     4,     3,     5,     2,   % center 1
     4,     2,     4,     5,     1,     4,   % center 2
     2,     5,     4,     1,     1,     3,   % center 3
     3,     2,     4,     4,     3,     4,   % center 4
     4,     1,     3,     5,     3,     5,   % center 5
     1,     2,     4,     1,     4,     2,   % center 6
     2,     1,     2,     5,     2,     4,   % center 7
     4,     4,     4,     5,     3,     1,   % center 8
     4,     2,     4,     2,     2,     4    % center 9
]);

int: totalDemand = sum(s in Stores)(demand[s]);

%------------------------------------------------------------
% Decision variables
%------------------------------------------------------------

array[Centers] of var 0..1: open;  % 1 if center is opened

% flow[f,s] = units shipped from center f to store s
array[Centers, Stores] of var 0..totalDemand: flow;

%------------------------------------------------------------
% Constraints
%------------------------------------------------------------

% Meet each store's demand exactly
constraint forall(s in Stores) (
  sum(f in Centers)(flow[f,s]) = demand[s]
);

% Respect each center's capacity; allow flow only if open
constraint forall(f in Centers) (
  sum(s in Stores)(flow[f,s]) <= cap[f] * open[f]
);

%------------------------------------------------------------
% Objective: minimize opening + transportation cost
%------------------------------------------------------------

var int: openTotal = sum(f in Centers)(openCost[f] * open[f]);
var int: shipTotal = sum(f in Centers, s in Stores)(shipCost[f,s] * flow[f,s]);
var int: totalCost = openTotal + shipTotal;

solve minimize totalCost;

%------------------------------------------------------------
% Output
%------------------------------------------------------------

output [
  "Total cost = ", show(totalCost), "\n",
  "Opening cost = ", show(openTotal), "\n",
  "Shipping cost = ", show(shipTotal), "\n\n",
  "Open centers (1=open): ", show(open), "\n\n",
  "Flows (rows=center 1..9, cols=store 1..6):\n",
  concat([ concat([ show(flow[f,s]) ++ if s==S then "\n" else "\t" endif
                  | s in Stores ])
         | f in Centers ])
];