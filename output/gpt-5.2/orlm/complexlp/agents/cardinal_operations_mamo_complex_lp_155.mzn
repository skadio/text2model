% Parameters
int: nCenters = 9;                          % number of potential distribution centers
int: nStores  = 5;                          % number of retail stores

set of int: CENTERS = 1..nCenters;
set of int: STORES  = 1..nStores;

array[CENTERS] of int: openCost =           % fixed opening cost for each center ($)
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[CENTERS, STORES] of int: shipCost =   % unit shipping cost from center i to store j ($/unit)
  array2d(CENTERS, STORES,
    [ 3, 5, 4, 3, 5,   % Center 1 -> Stores 1..5
      2, 4, 2, 4, 5,   % Center 2
      1, 4, 2, 5, 4,   % Center 3
      1, 1, 3, 3, 2,   % Center 4
      4, 4, 3, 4, 4,   % Center 5
      1, 3, 5, 3, 5,   % Center 6
      1, 2, 4, 1, 4,   % Center 7
      2, 2, 1, 2, 5,   % Center 8
      2, 4, 4, 4, 4 ]  % Center 9
  );

array[STORES] of int: demand =              % demand at each store (units)
  [908, 434, 605, 480, 961];

array[CENTERS] of int: capacity =           % supply capacity at each center (units)
  [1825, 1821, 1365, 1929, 1502, 1201, 1529, 961, 1001];

int: totalDemand = sum(j in STORES)(demand[j]); % helper bound for flow variables


% Variables
array[CENTERS] of var bool: open;           % open[i] = true if center i is opened

array[CENTERS, STORES] of var 0..totalDemand: shipQty;
  % shipQty[i,j] = units shipped from center i to store j

var int: totalCost;                         % total opening + shipping cost


% Constraints
% Link shipments to opening decision and capacity (cannot ship from a closed center;
% total outbound from a center cannot exceed its capacity if opened)
constraint
  forall(i in CENTERS) (
    sum(j in STORES)(shipQty[i,j]) <= capacity[i] * bool2int(open[i])
  );

% Demand satisfaction at each store (all demand must be met exactly)
constraint
  forall(j in STORES) (
    sum(i in CENTERS)(shipQty[i,j]) = demand[j]
  );

% Total cost definition (fixed opening costs + variable shipping costs)
constraint
  totalCost =
    sum(i in CENTERS)(openCost[i] * bool2int(open[i])) +
    sum(i in CENTERS, j in STORES)(shipCost[i,j] * shipQty[i,j]);


% Objective
solve minimize totalCost;