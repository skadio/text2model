int: NumProducts;
int: NumMachines;

array[1..NumProducts, 1..NumMachines] of int: ProduceTime;
array[1..NumMachines]                  of int: AvailableTime;
array[1..NumProducts]                  of int: Profit;

array[1..NumProducts] of int: MaxUnits =
[
  min([ AvailableTime[s] div ProduceTime[k,s] | s in 1..NumMachines ])
  | k in 1..NumProducts
];

array[1..NumProducts] of var int: Qty;

constraint
  forall(k in 1..NumProducts)(
    0 <= Qty[k] /\ Qty[k] <= MaxUnits[k]
  );

constraint
  forall(s in 1..NumMachines)(
    sum(k in 1..NumProducts)(ProduceTime[k,s] * Qty[k]) <= AvailableTime[s]
  );

solve maximize sum(k in 1..NumProducts)(Profit[k] * Qty[k]);