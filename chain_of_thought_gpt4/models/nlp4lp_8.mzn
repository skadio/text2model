% Parameters
int: NumParts;
int: NumMachines;
array[1..NumParts, 1..NumMachines] of int: Time;
array[1..NumParts] of int: Profit;
array[1..NumMachines] of int: Capacity;

% Variables
array[1..NumParts] of var 0..max(Capacity): PartsProduced;

% Constraints
constraint forall(s in 1..NumMachines)(
  sum(k in 1..NumParts)(Time[k,s]*PartsProduced[k]) <= Capacity[s]
);

% Objective
var int: TotalProfit = sum(k in 1..NumParts)(Profit[k]*PartsProduced[k]);
solve maximize TotalProfit;