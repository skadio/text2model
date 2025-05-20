include "globals.mzn";

% Number of different products
int: NumProducts;

% Number of different machines or stations
int: NumMachines;

% Time to produce one unit of product k on station s
array[1..NumProducts, 1..NumMachines] of int: ProduceTime;

% Total available time on station s
array[1..NumMachines] of int: AvailableTime;

% Profit from producing one unit of product k
array[1..NumProducts] of int: Profit;

% Decision variable: quantity of each product to produce
array[1..NumProducts] of var 0..sum(AvailableTime) div min([ProduceTime[k,s] | k in 1..NumProducts, s in 1..NumMachines]): Quantity;

% Objective: maximize total profit
var int: total_profit = sum(k in 1..NumProducts)(Profit[k]*Quantity[k]);
maximize total_profit;

% Constraints: production time for each product on each machine should not exceed available time
constraint forall(s in 1..NumMachines)(
  sum(k in 1..NumProducts)(ProduceTime[k,s]*Quantity[k]) <= AvailableTime[s]
);

solve satisfy;
output ["Total profit: ", show(total_profit), "\nQuantities: ", show(Quantity)];