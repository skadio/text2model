% Parameters
int: NumProducts;
int: NumMachines;
array[1..NumProducts, 1..NumMachines] of int: ProduceTime;
array[1..NumMachines] of int: AvailableTime;
array[1..NumProducts] of int: Profit;

% Variables
array[1..NumProducts] of var 0..sum(AvailableTime): Quantity;

% Constraints
constraint forall(s in 1..NumMachines) (
    sum(k in 1..NumProducts) (ProduceTime[k,s] * Quantity[k]) <= AvailableTime[s]
);

% Objective
var int: TotalProfit = sum(k in 1..NumProducts) (Profit[k] * Quantity[k]);
solve maximize TotalProfit;