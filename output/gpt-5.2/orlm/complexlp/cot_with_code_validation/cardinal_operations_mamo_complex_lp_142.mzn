% Global Supply Network Inc. - Facility location with capacitated shipping
% Data embedded directly in the model

int: N = 9; % distribution centers
int: M = 6; % retail stores

set of int: DC = 1..N;
set of int: ST = 1..M;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];
array[DC] of int: capacity = [1615, 1255, 1816, 1095, 1519, 1137, 1678, 1876, 1591];
array[ST] of int: demand   = [876, 801, 955, 561, 601, 669];

array[DC, ST] of int: transpCost =
array2d(DC, ST, [
  3, 5, 4, 3, 5, 2,   % DC1 -> S1..S6
  4, 2, 4, 5, 1, 4,   % DC2
  2, 5, 4, 1, 1, 3,   % DC3
  3, 2, 4, 4, 3, 4,   % DC4
  4, 1, 3, 5, 3, 5,   % DC5
  1, 2, 4, 1, 4, 2,   % DC6
  2, 1, 2, 5, 2, 4,   % DC7
  4, 4, 4, 5, 3, 1,   % DC8
  4, 2, 4, 2, 2, 4    % DC9
]);

int: totalDemand = sum(s in ST)(demand[s]);

% Decision variables
array[DC] of var bool: open;
array[DC, ST] of var 0..totalDemand: ship;

% Objective
var int: totalCost =
  sum(d in DC)(openCost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(transpCost[d, s] * ship[d, s]);

% Constraints: meet all store demands
constraint forall(s in ST)(
  sum(d in DC)(ship[d, s]) = demand[s]
);

% Constraints: do not exceed DC capacities unless opened
constraint forall(d in DC)(
  sum(s in ST)(ship[d, s]) <= capacity[d] * bool2int(open[d])
);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[d]) | d in DC]), "\n"
];