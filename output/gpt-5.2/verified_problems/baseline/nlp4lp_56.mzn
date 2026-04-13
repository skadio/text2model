int: NumPorts;
int: NumTerminals;

set of int: K = 1..NumTerminals; % terminals (sources)
set of int: L = 1..NumPorts;     % ports/destinations (sinks)

array[K,L] of int: Cost;         % cost per ton from terminal k to port l
array[L] of int: Demand;         % demand at port l
array[K] of int: Supply;         % supply at terminal k

array[K,L] of var 0..max(Supply): x; % tons shipped from terminal k to port l

constraint
  forall(k in K) (
    sum(l in L)(x[k,l]) <= Supply[k]
  );

constraint
  forall(l in L) (
    sum(k in K)(x[k,l]) == Demand[l]
  );

solve minimize sum(k in K, l in L)(Cost[k,l] * x[k,l]);

output [
  "TotalCost=", show(sum(k in K, l in L)(Cost[k,l] * x[k,l])), "\n",
  "x=\n"
] ++
[
  "Terminal ", show(k), ": ", show([ x[k,l] | l in L ]), "\n"
  | k in K
];