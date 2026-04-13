% Parameters
int: nDC = 8;                      % number of candidate distribution centers
int: nStores = 8;                  % number of retail stores

set of int: DC = 1..nDC;
set of int: Stores = 1..nStores;

array[DC] of int: openCost =       % fixed opening cost for each DC ($)
  [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000];

% Transportation costs per unit from DC i to Store j ($/unit)
array[DC, Stores] of int: transCost =
  [| 3, 5, 4, 6, 3, 4, 5, 4
   | 2, 3, 5, 4, 6, 5, 3, 4
   | 4, 4, 3, 5, 4, 6, 4, 3
   | 5, 6, 4, 3, 5, 4, 6, 5
   | 3, 4, 6, 5, 3, 5, 4, 6
   | 4, 3, 5, 4, 6, 3, 5, 4
   | 6, 5, 4, 6, 5, 4, 3, 5
   | 5, 4, 3, 5, 4, 6, 5, 4 |];

array[Stores] of int: demand =     % demand at each store (units)
  [695, 752, 510, 831, 604, 417, 563, 440];

array[DC] of int: capacity =       % supply capacity at each DC (units)
  [1980, 2350, 1800, 2100, 2045, 1900, 2200, 1962];

int: totalDemand = sum(s in Stores)(demand[s]);   % total demand (units)
int: maxShip = totalDemand;                       % safe upper bound for any shipment


% Variables
array[DC] of var bool: open;                      % true if DC is opened

array[DC, Stores] of var 0..maxShip: ship;        % units shipped from DC i to Store j


% Constraints

% Demand fulfillment: each store's demand must be met exactly
constraint
  forall(s in Stores) (
    sum(d in DC)(ship[d, s]) = demand[s]
  );

% Capacity and opening linkage: total shipped out of a DC cannot exceed its capacity when opened
constraint
  forall(d in DC) (
    sum(s in Stores)(ship[d, s]) <= capacity[d] * bool2int(open[d])
  );

% (Redundant but strengthening) No shipment on an arc if DC is closed
constraint
  forall(d in DC, s in Stores) (
    ship[d, s] <= demand[s] * bool2int(open[d])
  );

% At least one DC must be open (explicit feasibility/clarity constraint)
constraint
  sum(d in DC)(bool2int(open[d])) >= 1;


% Objective
solve minimize
  sum(d in DC)(openCost[d] * bool2int(open[d]))
+ sum(d in DC, s in Stores)(transCost[d, s] * ship[d, s]);