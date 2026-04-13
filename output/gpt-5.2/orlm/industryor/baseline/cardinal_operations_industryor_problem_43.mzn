% Transshipment with fixed-charge intermediate stations
% All data embedded

int: m = 2; % production points
int: n = 2; % demand points
int: p = 2; % intermediate stations

set of int: I = 1..m;
set of int: J = 1..n;
set of int: K = 1..p;

array[I] of int: a = [100, 150]; % supplies
array[J] of int: b = [80, 120];  % demands

array[K] of int: f = [10, 15];   % fixed cost to open station
array[K] of int: q = [100, 100]; % station capacity

array[I, K] of int: c = array2d(I, K,
  [ 2, 3,
    4, 1 ]
);

array[K, J] of int: cp = array2d(K, J,
  [ 3, 2,
    1, 4 ]
);

% Decision variables
array[I, K] of var 0..max(a): x;    % shipped i -> k
array[K, J] of var 0..max(b): y;    % shipped k -> j
array[K] of var bool: open;         % whether station k is used

% Supply constraints
constraint forall(i in I)(
  sum(k in K)(x[i,k]) <= a[i]
);

% Demand constraints (must be met)
constraint forall(j in J)(
  sum(k in K)(y[k,j]) = b[j]
);

% Flow conservation at intermediate stations
constraint forall(k in K)(
  sum(i in I)(x[i,k]) = sum(j in J)(y[k,j])
);

% Capacity and activation constraints
constraint forall(k in K)(
  sum(i in I)(x[i,k]) <= q[k] * bool2int(open[k])
);

% Objective: variable transport costs + fixed station costs
var int: total_cost =
  sum(i in I, k in K)(c[i,k] * x[i,k]) +
  sum(k in K, j in J)(cp[k,j] * y[k,j]) +
  sum(k in K)(f[k] * bool2int(open[k]));

solve minimize total_cost;

output [
  "Total cost = ", show(total_cost), "\n",
  "Open stations (k=1..p): ", show([bool2int(open[k]) | k in K]), "\n\n",
  "Shipments x(i,k):\n",
  concat([ "i=" ++ show(i) ++ ": " ++ show([x[i,k] | k in K]) ++ "\n" | i in I ]),
  "\nShipments y(k,j):\n",
  concat([ "k=" ++ show(k) ++ ": " ++ show([y[k,j] | j in J]) ++ "\n" | k in K ])
];