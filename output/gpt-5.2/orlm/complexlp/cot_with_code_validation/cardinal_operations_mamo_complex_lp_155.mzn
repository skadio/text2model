% GlobalSupply Inc. - Facility location with shipping (MIP)

int: N = 9; % distribution centers
int: M = 5; % retail stores

set of int: DC = 1..N;
set of int: ST = 1..M;

array[DC] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000];

array[DC, ST] of int: transCost =
 [| 3, 5, 4, 3, 5
  | 2, 4, 2, 4, 5
  | 1, 4, 2, 5, 4
  | 1, 1, 3, 3, 2
  | 4, 4, 3, 4, 4
  | 1, 3, 5, 3, 5
  | 1, 2, 4, 1, 4
  | 2, 2, 1, 2, 5
  | 2, 4, 4, 4, 4 |];

array[ST] of int: demand = [908, 434, 605, 480, 961];
array[DC] of int: capacity = [1825, 1821, 1365, 1929, 1502, 1201, 1529, 961, 1001];

int: totalDemand = sum(s in ST)(demand[s]);

% --- Variables ---
array[DC] of var bool: open;
array[DC, ST] of var 0..totalDemand: ship;

% Compute a safe (tight-ish) upper bound to avoid very large domains
int: maxTrans = max([transCost[d,s] | d in DC, s in ST]);
int: ubTotalCost = sum(d in DC)(openCost[d]) + totalDemand * maxTrans;

var 0..ubTotalCost: totalCost;

% --- Constraints ---
% Meet each store's demand exactly
constraint forall(s in ST) (
  sum(d in DC)(ship[d,s]) = demand[s]
);

% Respect capacity if a DC is open
constraint forall(d in DC) (
  sum(s in ST)(ship[d,s]) <= capacity[d] * bool2int(open[d])
);

% Objective definition
constraint totalCost =
  sum(d in DC)(openCost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(transCost[d,s] * ship[d,s]);

% Provide a better default search to avoid timeouts on CP backends
solve :: int_search([bool2int(open[d]) | d in DC] ++ [ship[d,s] | d in DC, s in ST],
                    first_fail, indomain_min, complete)
minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show([bool2int(open[d]) | d in DC]), "\n"
];