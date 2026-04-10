int: NumParts;
int: NumMachines;

array[1..NumParts, 1..NumMachines] of int: Time;
array[1..NumParts] of int: Profit;
array[1..NumMachines] of int: Capacity;

array[1..NumParts] of var int: Make;

constraint forall(k in 1..NumParts)(Make[k] >= 0);

constraint
  forall(s in 1..NumMachines)(
    sum(k in 1..NumParts)(Time[k, s] * Make[k]) <= Capacity[s]
  );

var int: TotalProfit = sum(k in 1..NumParts)(Profit[k] * Make[k]);

solve maximize TotalProfit;

output [
  "TotalProfit = ", show(TotalProfit), "\n",
  "Make = ", show(Make), "\n"
];