include "globals.mzn";

%----- Data (embedded as required) -----
int: m = 2; % production points
int: n = 2; % demand points
int: p = 2; % transshipment stations

array[1..m] of int: a = [100, 150];  % supplies
array[1..n] of int: b = [80, 120];   % demands

array[1..p] of int: f = [10, 15];    % fixed cost if station k is used
array[1..p] of int: q = [100, 100];  % capacity of station k

array[1..m, 1..p] of int: c = array2d(1..m, 1..p,
  [ 2, 3,
    4, 1 ]);                         % i->k unit costs

array[1..p, 1..n] of int: cp = array2d(1..p, 1..n,
  [ 3, 2,
    1, 4 ]);                         % k->j unit costs

%----- Decision variables -----
% Flow from production i to station k
array[1..m, 1..p] of var 0..max(a): x;

% Flow from station k to demand j
array[1..p, 1..n] of var 0..max(a): y;

% Whether station k is used (incurs fixed cost f[k])
array[1..p] of var 0..1: use;

%----- Constraints -----

% Supply limits at production points
constraint forall(i in 1..m)(
  sum(k in 1..p)(x[i,k]) <= a[i]
);

% Demand must be met exactly at demand points
constraint forall(j in 1..n)(
  sum(k in 1..p)(y[k,j]) = b[j]
);

% Flow conservation at each station (inflow = outflow)
constraint forall(k in 1..p)(
  sum(i in 1..m)(x[i,k]) = sum(j in 1..n)(y[k,j])
);

% Capacity at each station and linking to use[k]
constraint forall(k in 1..p)(
  sum(i in 1..m)(x[i,k]) <= q[k] * use[k]
);

%----- Objective -----
var int: total_cost =
    sum(i in 1..m, k in 1..p)(c[i,k] * x[i,k])
  + sum(k in 1..p, j in 1..n)(cp[k,j] * y[k,j])
  + sum(k in 1..p)(f[k] * use[k]);

solve minimize total_cost;

%----- Output -----
output [
  "Total cost = ", show(total_cost), "\n",
  "use = ", show(use), "\n",
  "x (i->k) =\n", show(x), "\n",
  "y (k->j) =\n", show(y), "\n"
];