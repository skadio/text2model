int: NumProducts;
int: NumMachines;
array[1..NumProducts, 1..NumMachines] of int: ProduceTime;
array[1..NumMachines] of int: AvailableTime;
array[1..NumProducts] of int: Profit;

var int: quantity[1..NumProducts] >= 0;

constraint
  forall(s in 1..NumMachines) (
    sum(k in 1..NumProducts) (quantity[k] * ProduceTime[k,s]) <= AvailableTime[s]
  );

solve maximize
  sum(k in 1..NumProducts) (quantity[k] * Profit[k]);

output [
  "Quantity: ", show(quantity), "\n",
  "Total Profit: ", show(sum(k in 1..NumProducts) (quantity[k] * Profit[k])), "\n"
];