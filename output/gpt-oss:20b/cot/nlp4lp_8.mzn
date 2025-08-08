% Parameters
int: NumParts;
int: NumMachines;
array[1..NumParts, 1..NumMachines] of int: Time;
array[1..NumParts] of int: Profit;
array[1..NumMachines] of int: Capacity;

% Variables
var int: x[1..NumParts] >= 0;

% Constraints
constraint
  forall(s in 1..NumMachines) (
    sum(k in 1..NumParts) (Time[k,s] * x[k]) <= Capacity[s]
  );

% Objective
solve maximize
  sum(k in 1..NumParts) (Profit[k] * x[k]);