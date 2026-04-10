% Parameters
int: m = 2; % number of production points
int: n = 2; % number of demand points
int: p = 2; % number of intermediate marshaling stations

set of int: I = 1..m; % production index set
set of int: J = 1..n; % demand index set
set of int: K = 1..p; % station index set

array[I] of int: a = [100, 150]; % supply at production points
array[J] of int: b = [80, 120];  % demand at demand points

array[K] of int: f = [10, 15];   % fixed cost for using station k
array[K] of int: q = [100, 100]; % capacity of station k

array[I, K] of int: c =
 [| 2, 3
  | 4, 1 |]; % unit cost from production i to station k

array[K, J] of int: c2 =
 [| 3, 2
  | 1, 4 |]; % unit cost from station k to demand j


% Variables
array[I, K] of var 0..max(a): x; % shipped quantity from production i to station k
array[K, J] of var 0..max(b): y; % shipped quantity from station k to demand j
array[K] of var bool: useStation; % true if station k is used (incurs fixed cost)


% Constraints
%--- Supply constraints: shipments out of each production point cannot exceed supply ---
constraint
  forall(i in I) (
    sum(k in K)(x[i,k]) <= a[i]
  );

%--- Demand constraints: total shipments into each demand point must meet demand exactly ---
constraint
  forall(j in J) (
    sum(k in K)(y[k,j]) == b[j]
  );

%--- Flow conservation at each station: inflow equals outflow ---
constraint
  forall(k in K) (
    sum(i in I)(x[i,k]) == sum(j in J)(y[k,j])
  );

%--- Station capacity and activation: transshipped volume limited by capacity if used ---
constraint
  forall(k in K) (
    sum(i in I)(x[i,k]) <= q[k] * bool2int(useStation[k])
  );

%--- Linking (redundant but strengthening): if station not used, no outbound shipment either ---
constraint
  forall(k in K) (
    sum(j in J)(y[k,j]) <= q[k] * bool2int(useStation[k])
  );


% Objective
solve minimize
    sum(i in I, k in K)(c[i,k] * x[i,k])
  + sum(k in K, j in J)(c2[k,j] * y[k,j])
  + sum(k in K)(f[k] * bool2int(useStation[k]));