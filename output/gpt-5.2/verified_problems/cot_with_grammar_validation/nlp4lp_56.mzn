int: NumPorts;
int: NumTerminals;

set of int: K = 1..NumTerminals;
set of int: L = 1..NumPorts;

array[K, L] of int: Cost;
array[L] of int: Demand;
array[K] of int: Supply;

int: TotalSupply = sum(k in K)(Supply[k]);
int: TotalDemand = sum(l in L)(Demand[l]);
int: MaxFlow = if TotalSupply < TotalDemand then TotalSupply else TotalDemand endif;

array[K, L] of var 0..MaxFlow: Ship;

var 0..sum(k in K, l in L)(Cost[k,l] * MaxFlow): TotalCost;

constraint forall(k in K)(Supply[k] >= 0);
constraint forall(l in L)(Demand[l] >= 0);
constraint forall(k in K, l in L)(Cost[k,l] >= 0);

constraint forall(k in K)(
  sum(l in L)(Ship[k,l]) <= Supply[k]
);

constraint forall(l in L)(
  sum(k in K)(Ship[k,l]) >= Demand[l]
);

constraint TotalCost = sum(k in K, l in L)(Cost[k,l] * Ship[k,l]);

solve minimize TotalCost;