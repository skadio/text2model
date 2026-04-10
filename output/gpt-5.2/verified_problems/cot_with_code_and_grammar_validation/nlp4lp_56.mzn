int: NumPorts;
int: NumTerminals;

set of int: K = 1..NumTerminals;
set of int: L = 1..NumPorts;

array[K, L] of int: Cost;
array[L] of int: Demand;
array[K] of int: Supply;

constraint sum(k in K)(Supply[k]) >= sum(l in L)(Demand[l]);

int: MaxShip = max(sum(k in K)(Supply[k]), sum(l in L)(Demand[l]));
array[K, L] of var 0..MaxShip: x;

constraint forall(k in K) (
  sum(l in L)(x[k,l]) <= Supply[k]
);

constraint forall(l in L) (
  sum(k in K)(x[k,l]) = Demand[l]
);

solve minimize sum(k in K, l in L)(Cost[k,l] * x[k,l]);