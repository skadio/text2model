% Parameters
int: NumProducts;
int: NumMachines;
array[1..NumProducts, 1..NumMachines] of int: ProduceTime;
array[1..NumMachines] of int: AvailableTime;
array[1..NumProducts] of int: Profit;

% Variables
var 0..sum(AvailableTime) : quantity[1..NumProducts];

% Constraints
constraint
  forall(s in 1..NumMachines) (
    sum(k in 1..NumProducts) ProduceTime[k,s] * quantity[k] <= AvailableTime[s]
  );

% Objective
solve maximize
  sum(k in 1..NumProducts) Profit[k] * quantity[k];