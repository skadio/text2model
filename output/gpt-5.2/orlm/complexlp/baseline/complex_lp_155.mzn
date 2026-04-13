% Facility Location / Capacitated Distribution Center Problem
% All data embedded directly in this model.

int: m = 9; % potential distribution centers
int: n = 5; % retail stores

set of int: DC = 1..m;
set of int: ST = 1..n;

array[DC] of int: open_cost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000
];

array[DC, ST] of int: trans_cost = array2d(DC, ST, [
  3,5,4,3,5,
  2,4,2,4,5,
  1,4,2,5,4,
  1,1,3,3,2,
  4,4,3,4,4,
  1,3,5,3,5,
  1,2,4,1,4,
  2,2,1,2,5,
  2,4,4,4,4
]);

array[ST] of int: demand = [908, 434, 605, 480, 961];

array[DC] of int: capacity = [1825, 1821, 1365, 1929, 1502, 1201, 1529, 961, 1001];

% Decision variables
array[DC] of var bool: open;
array[DC, ST] of var 0..max(demand): ship;

% Demand must be met exactly
constraint forall(j in ST) (
  sum(i in DC)(ship[i,j]) = demand[j]
);

% Capacity constraints and linking to opening decision
constraint forall(i in DC) (
  sum(j in ST)(ship[i,j]) <= capacity[i] * bool2int(open[i])
);

% Objective: opening + transportation costs
var int: total_open_cost = sum(i in DC)(open_cost[i] * bool2int(open[i]));
var int: total_trans_cost = sum(i in DC, j in ST)(trans_cost[i,j] * ship[i,j]);
var int: total_cost = total_open_cost + total_trans_cost;

solve minimize total_cost;

output [
  "Optimal total cost = ", show(total_cost), "\n",
  "Opening cost = ", show(total_open_cost), "\n",
  "Transportation cost = ", show(total_trans_cost), "\n\n",
  "Open centers (1=yes,0=no):\n",
  concat([ "Center ", show(i), ": ", show(bool2int(open[i])), "\n" | i in DC ]),
  "\nShipments (units shipped from center i to store j):\n",
  concat([ "Center " ++ show(i) ++ ": " ++
           concat([ "S" ++ show(j) ++ "=" ++ show(ship[i,j]) ++ (if j < n then "  " else "\n" endif)
                 | j in ST ])
         | i in DC ])
];