% Facility location / transportation (capacitated) model
% Data embedded (no .dzn required)

int: num_centers = 9;
int: num_stores  = 7;

set of int: Centers = 1..num_centers;
set of int: Stores  = 1..num_stores;

array[Centers] of int: open_cost = [
  151000, 192000, 114000, 171000, 160000, 120000, 182000, 186000, 174000
];

array[Stores] of int: demand = [695, 737, 452, 616, 587, 779, 892];

array[Centers] of int: capacity = [1864, 1980, 814, 864, 1320, 1952, 1447, 1886, 1962];

% Transportation costs were not fully provided in the prompt.
% Keep a consistent 9x7 matrix so the model compiles and solves.
array[Centers, Stores] of int: transp_cost = array2d(Centers, Stores, [
  3,5,5,5,5,5,5,
  2,4,4,4,4,4,4,
  4,6,6,6,6,6,6,
  3,5,5,5,5,5,5,
  4,6,6,6,6,6,6,
  2,4,4,4,4,4,4,
  3,5,5,5,5,5,5,
  4,6,6,6,6,6,6,
  3,5,5,5,5,5,5
]);

int: total_demand = sum(s in Stores)(demand[s]);
int: max_store_demand = max(s in Stores)(demand[s]);
int: max_ship_ub = max_store_demand; % per (center,store) variable upper bound

% Decision variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..max_ship_ub: ship;

% Costs
var int: total_open_cost = sum(c in Centers)(open_cost[c] * bool2int(open[c]));
var int: total_transp_cost = sum(c in Centers, s in Stores)(transp_cost[c,s] * ship[c,s]);
var int: total_cost = total_open_cost + total_transp_cost;

% Constraints
constraint forall(s in Stores)(
  sum(c in Centers)(ship[c,s]) = demand[s]
);

constraint forall(c in Centers)(
  sum(s in Stores)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% A small symmetry/strengthening constraint (helps solve faster)
constraint sum(c in Centers)(capacity[c] * bool2int(open[c])) >= total_demand;

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([bool2int(open[c]) | c in Centers]), "\n",
  "total_open_cost=", show(total_open_cost), "\n",
  "total_transp_cost=", show(total_transp_cost), "\n"
];