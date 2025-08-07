int: NumParts;
int: NumMachines;

array[1..NumParts, 1..NumMachines] of int: Time;
array[1..NumParts] of int: Profit;
array[1..NumMachines] of int: Capacity;

array[1..NumParts] of var 0..maxint: Qty;

constraint
  forall(s in 1..NumMachines) (
    sum(k in 1..NumParts) (Time[k,s] * Qty[k]) <= Capacity[s]
  );

solve maximize
  sum(k in 1..NumParts) (Profit[k] * Qty[k]);

output [
  "Production plan:\n",
  concat([ "  Part " ++ show(k) ++ ": " ++ show(Qty[k]) ++ "\n" | k in 1..NumParts ]),
  "Total profit: " ++ show(sum(k in 1..NumParts) (Profit[k] * Qty[k])) ++ "\n"
];