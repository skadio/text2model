% Facility Location / Distribution Center Opening with Capacitated Transportation
% All data embedded as requested.

int: F = 9; % potential distribution centers
int: S = 6; % retail stores

set of int: DC = 1..F;
set of int: ST = 1..S;

array[DC] of int: openCost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000
];

array[DC, ST] of int: shipCost = array2d(DC, ST, [
  3,5,4,3,5,2,   % DC1 -> stores 1..6
  4,2,4,5,1,4,   % DC2
  2,5,4,1,1,3,   % DC3
  3,2,4,4,3,4,   % DC4
  4,1,3,5,3,5,   % DC5
  1,2,4,1,4,2,   % DC6
  2,1,2,5,2,4,   % DC7
  4,4,4,5,3,1,   % DC8
  4,2,4,2,2,4    % DC9
]);

array[ST] of int: demand = [876, 801, 955, 561, 601, 669];

array[DC] of int: capacity = [1615, 1255, 1816, 1095, 1519, 1137, 1678, 1876, 1591];

int: totalDemand = sum(s in ST)(demand[s]);

% Decision variables
array[DC] of var bool: open;
array[DC, ST] of var 0..max(demand): x; % units shipped from DC d to store s

% Constraints: meet each store demand exactly
constraint forall(s in ST)(
  sum(d in DC)(x[d,s]) = demand[s]
);

% Capacity constraints linked to opening decisions
constraint forall(d in DC)(
  sum(s in ST)(x[d,s]) <= capacity[d] * bool2int(open[d])
);

% Objective: opening costs + transportation costs
var int: totalCost =
  sum(d in DC)(openCost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(shipCost[d,s] * x[d,s]);

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "Open DCs: ", show([d | d in DC where fix(open[d]) == true]), "\n",
  "Shipments (dc,store,units):\n"
] ++
[
  if fix(x[d,s]) > 0 then
    "  (" ++ show(d) ++ "," ++ show(s) ++ "," ++ show(x[d,s]) ++ ")\n"
  else
    ""
  endif
  | d in DC, s in ST
];