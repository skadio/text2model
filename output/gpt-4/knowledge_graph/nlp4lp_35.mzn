include "globals.mzn";

% Parameters
int: NumProducts; % Number of different products
int: NumMachines; % Number of different machines or stations
array[1..NumProducts, 1..NumMachines] of int: ProduceTime; % Time to produce one unit of product k on station s
array[1..NumMachines] of int: AvailableTime; % Total available time on station s
array[1..NumProducts] of int: Profit; % Profit from producing one unit of product k

% Variables
array[1..NumProducts] of var 0..max(AvailableTime) div min([ProduceTime[k,s] | k in 1..NumProducts, s in 1..NumMachines]): QuantityProduced; % Quantity of each product to be produced

% Constraints
constraint forall(s in 1..NumMachines)(
  sum(k in 1..NumProducts)(ProduceTime[k,s]*QuantityProduced[k]) <= AvailableTime[s]
);

% Objective
var int: TotalProfit = sum(k in 1..NumProducts)(Profit[k]*QuantityProduced[k]);
solve maximize TotalProfit;

% Output
output ["Total Profit: ", show(TotalProfit), "\n"] ++
["Quantity Produced: "] ++ [show(QuantityProduced[k]) | k in 1..NumProducts];