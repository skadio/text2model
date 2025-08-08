include "globals.mzn";

int: NumProducts;                          % Number of different products
int: NumMachines;                           % Number of different machines or stations
array[1..NumProducts, 1..NumMachines] of int: ProduceTime; % Time to produce one unit of product k on station s
array[1..NumMachines] of int: AvailableTime; % Total available time on station s
array[1..NumProducts] of int: Profit;      % Profit from producing one unit of product k

/* Decision variables */
array[1..NumProducts] of var 0..max(AvailableTime) div min(ProduceTime): quantity; % Quantity of each product to produce

/* Constraints */
array[1..NumMachines] of var 0..max(AvailableTime): totalTime; % Total time used on each machine

% Calculate total time used on each machine
constraint forall(s in 1..NumMachines) (
    totalTime[s] = sum(k in 1..NumProducts)(quantity[k] * ProduceTime[k, s])
);

% Ensure that total time used does not exceed available time
constraint forall(s in 1..NumMachines) (
    totalTime[s] <= AvailableTime[s]
);

/* Objective function: Maximize total profit */
var int: totalProfit = sum(k in 1..NumProducts)(quantity[k] * Profit[k]);
solve maximize totalProfit;

/* Output */
output [ "Quantity = ", show(quantity), "\nTotal Profit = ", show(totalProfit), "\n" ];