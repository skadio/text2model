% Facility Location / Distribution Planning (embedded data)

int: nCenters = 8;
int: nStores  = 9;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

array[CENTERS] of int: capacity =
  [1447, 1886, 1962, 1392, 1191, 1218, 1088, 1178];

array[STORES] of int: demand =
  [779, 892, 440, 556, 414, 464, 920, 743, 528];

% The full 8x9 transportation cost matrix is not provided in the prompt (only ranges).
% To keep the model runnable and avoid timeouts from huge domains, we use a consistent
% low/typical cost within the stated ranges (1..5). Replace with real data if available.
array[CENTERS, STORES] of int: transCost =
  array2d(CENTERS, STORES, [
    2,2,2,2,2,2,2,2,2,   % center 1
    2,2,2,2,2,2,2,2,2,   % center 2
    2,2,2,2,2,2,2,2,2,   % center 3
    2,2,2,2,2,2,2,2,2,   % center 4
    2,2,2,2,2,2,2,2,2,   % center 5
    2,2,2,2,2,2,2,2,2,   % center 6
    2,2,2,2,2,2,2,2,2,   % center 7
    2,2,2,2,2,2,2,2,2    % center 8
  ]);

int: totalDemand = sum(s in STORES)(demand[s]);

% Decision variables
array[CENTERS] of var bool: open;
array[CENTERS, STORES] of var 0..max(demand): ship;

% Constraints: satisfy each store demand exactly
constraint forall(s in STORES)(
  sum(c in CENTERS)(ship[c,s]) = demand[s]
);

% Constraints: capacity and linking (if not open then no shipments)
constraint forall(c in CENTERS)(
  sum(s in STORES)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Objective
var int: totalCost =
    sum(c in CENTERS)(openCost[c] * bool2int(open[c])) +
    sum(c in CENTERS, s in STORES)(transCost[c,s] * ship[c,s]);

solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[c]) | c in CENTERS]), "\n"
];