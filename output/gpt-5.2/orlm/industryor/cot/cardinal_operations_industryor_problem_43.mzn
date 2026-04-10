% Parameters (with values embedded)
int: m = 2;
int: n = 2;
int: p = 2;

set of int: I = 1..m;
set of int: J = 1..n;
set of int: K = 1..p;

array[I] of int: a = [100, 150];          % supply at production points
array[J] of int: b = [80, 120];           % demand at demand points

array[K] of int: f = [10, 15];            % fixed cost for using station k
array[K] of int: q = [100, 100];          % capacity of station k

array[I, K] of int: c = array2d(I, K,     % unit cost i -> k
  [ 2, 3,
    4, 1 ]);

array[K, J] of int: c2 = array2d(K, J,    % unit cost k -> j
  [ 3, 2,
    1, 4 ]);

int: total_supply = sum(i in I)(a[i]);
int: total_demand = sum(j in J)(b[j]);
int: BIGM = total_demand;                 % sufficient linking constant

% Variables
array[I, K] of var 0..BIGM: x;            % flow from i to k
array[K, J] of var 0..BIGM: y;            % flow from k to j
array[K] of var 0..1: use;                % 1 if station k is used

var 0..1000000: total_cost;

% Constraints
constraint total_supply >= total_demand;

% Supply limits (can leave unused supply)
constraint forall(i in I)(
  sum(k in K)(x[i,k]) <= a[i]
);

% Demand must be met exactly
constraint forall(j in J)(
  sum(k in K)(y[k,j]) = b[j]
);

% Flow conservation through each station
constraint forall(k in K)(
  sum(i in I)(x[i,k]) = sum(j in J)(y[k,j])
);

% Station capacity and activation
constraint forall(k in K)(
  sum(i in I)(x[i,k]) <= q[k]
);
constraint forall(k in K)(
  sum(i in I)(x[i,k]) <= BIGM * use[k]
);

% Objective
constraint total_cost =
    sum(i in I, k in K)(c[i,k] * x[i,k])
  + sum(k in K, j in J)(c2[k,j] * y[k,j])
  + sum(k in K)(f[k] * use[k]);

solve minimize total_cost;