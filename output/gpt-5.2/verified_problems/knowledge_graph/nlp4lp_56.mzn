int: NumPorts;
int: NumTerminals;

set of int: K = 1..NumTerminals;
set of int: L = 1..NumPorts;

array[K, L] of int: Cost;
array[L] of int: Demand;
array[K] of int: Supply;

array[K, L] of var 0..max(Supply): Quantity;

constraint
  forall(k in K) (
    sum(l in L)(Quantity[k,l]) <= Supply[k]
  );

constraint
  forall(l in L) (
    sum(k in K)(Quantity[k,l]) >= Demand[l]
  );

var int: TotalCost = sum(k in K, l in L)(Cost[k,l] * Quantity[k,l]);

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "Quantity =\n",
  concat([ concat([ show(Quantity[k,l]) ++ if l < NumPorts then " " else "" endif
                  | l in L ]) ++ "\n"
         | k in K ])
];