include "globals.mzn";

% --- Parameters -----------------------------------------------------------

int: NumProducts;          % number of products
int: NumMachines;          % number of machines / stations

array[1..NumProducts, 1..NumMachines] of int: ProduceTime;  % time per unit
array[1..NumMachines]          of int: AvailableTime;      % available time
array[1..NumProducts]          of int: Profit;              % profit per unit

% --- Decision variables ---------------------------------------------------

array[1..NumProducts] of var 0..10000: produce;  % units to produce

% --- Constraints -----------------------------------------------------------

constraint
  forall(s in 1..NumMachines)(
    sum(k in 1..NumProducts) ProduceTime[k,s] * produce[k] <= AvailableTime[s]
  );

% --- Objective -------------------------------------------------------------

var int: totalProfit = sum(k in 1..NumProducts) Profit[k] * produce[k];

solve maximize totalProfit;

% --- Output ---------------------------------------------------------------

output [
  "Total profit: ", show(totalProfit), "\n",
  "Production quantities: ", show(produce), "\n"
];