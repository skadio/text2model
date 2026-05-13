int: NumPorts;
int: NumTerminals;

array[1..NumTerminals, 1..NumPorts] of int: Cost;
array[1..NumPorts] of int: Demand;
array[1..NumTerminals] of int: Supply;

int: maxSupply = max(Supply);

array[1..NumTerminals, 1..NumPorts] of var 0..maxSupply: flow;

constraint
  forall(k in 1..NumTerminals) (
    sum(l in 1..NumPorts)(flow[k,l]) <= Supply[k]
  );

constraint
  forall(l in 1..NumPorts) (
    sum(k in 1..NumTerminals)(flow[k,l]) = Demand[l]
  );

var int: totalCost = sum(k in 1..NumTerminals, l in 1..NumPorts)(Cost[k,l] * flow[k,l]);

solve minimize totalCost;

output [
  "Total cost: ", show(totalCost), "\n",
  "Flows (terminal x port):\n",
  show(flow), "\n"
];