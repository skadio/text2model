% Facility location / transportation with capacities
% Data embedded as requested

int: M = 8; % distribution centers
int: N = 5; % retail stores

set of int: CENTERS = 1..M;
set of int: STORES  = 1..N;

array[CENTERS] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[CENTERS, STORES] of int: transCost =
[| 3, 3, 5, 4, 3
 | 5, 2, 4, 2, 4
 | 5, 1, 4, 2, 5
 | 4, 1, 1, 3, 3
 | 2, 4, 4, 3, 4
 | 4, 1, 3, 5, 3
 | 5, 1, 2, 4, 1
 | 4, 2, 2, 1, 2 |];

array[STORES] of int: demand = [964, 739, 491, 766, 854];
array[CENTERS] of int: capacity = [1308, 1575, 834, 1005, 1904, 1825, 1821, 1365];

int: totalDemand = sum(s in STORES)(demand[s]);

% Decision variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..totalDemand: ship;

% Constraints: satisfy all demands
constraint forall(s in STORES)(
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

% Capacity only if center is open
constraint forall(c in CENTERS)(
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Objective: minimize opening + transport cost
var int: totalCost =
  sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
  sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);

solve :: int_search([ship[c,s] | c in CENTERS, s in STORES] ++ [bool2int(open[c]) | c in CENTERS],
                    first_fail, indomain_min, complete)
minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[c]) | c in CENTERS]), "\n",
  "ship=\n"
] ++
[ if s = 1 then "" else "" endif ++
  concat([ show(ship[c,s]) ++ (if c = M then "\n" else " " endif) | c in CENTERS ])
  | s in STORES
];