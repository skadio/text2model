% Facility location / transportation problem (embedded data)

% Parameters
int: nCenters = 8;
int: nStores  = 9;

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

% Unit transport costs (center x store)
array[CENTERS, STORES] of int: transportCost =
  array2d(CENTERS, STORES, [
    % Center 1
    3, 3, 5, 4, 3, 5, 2, 4, 2,
    % Center 2
    4, 5, 1, 4, 2, 5, 4, 1, 1,
    % Center 3
    3, 3, 2, 4, 4, 3, 4, 4, 1,
    % Center 4
    3, 5, 3, 5, 1, 2, 4, 1, 4,
    % Center 5
    2, 2, 1, 2, 5, 2, 4, 4, 4,
    % Center 6
    4, 5, 3, 1, 4, 2, 4, 2, 2,
    % Center 7
    4, 5, 2, 2, 4, 2, 2, 4, 4,
    % Center 8
    1, 5, 5, 2, 5, 2, 1, 4, 4
  ]);

array[STORES] of int: demand =
  [779, 892, 440, 556, 414, 464, 920, 743, 528];

array[CENTERS] of int: capacity =
  [1447, 1886, 1962, 1392, 1191, 1218, 1088, 1178];

int: totalDemand = sum(s in STORES)(demand[s]);

% Decision variables
array[CENTERS] of var bool: isOpen;
array[CENTERS, STORES] of var 0..totalDemand: shipQty;

% Constraints

% Meet each store's demand exactly
constraint forall(s in STORES)(
  sum(c in CENTERS)(shipQty[c,s]) = demand[s]
);

% Capacity only if open
constraint forall(c in CENTERS)(
  sum(s in STORES)(shipQty[c,s]) <= capacity[c] * bool2int(isOpen[c])
);

% Objective: minimize opening + shipping costs
solve minimize
  sum(c in CENTERS)(openCost[c] * bool2int(isOpen[c]))
+ sum(c in CENTERS, s in STORES)(transportCost[c,s] * shipQty[c,s]);