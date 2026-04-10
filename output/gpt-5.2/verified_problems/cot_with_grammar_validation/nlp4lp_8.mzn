% Parameters
int: NumParts;
int: NumMachines;

set of int: PARTS = 1..NumParts;
set of int: MACHINES = 1..NumMachines;

array[PARTS, MACHINES] of int: Time;
array[PARTS] of int: Profit;
array[MACHINES] of int: Capacity;

% Variables
array[PARTS] of var 0..max(Capacity): Make;

var int: TotalProfit;

% Constraints
constraint
  forall(k in PARTS, s in MACHINES) (Time[k,s] >= 0) /\
  forall(k in PARTS) (Profit[k] >= 0) /\
  forall(s in MACHINES) (Capacity[s] >= 0);

constraint
  forall(s in MACHINES) (
    sum(k in PARTS) (Time[k,s] * Make[k]) <= Capacity[s]
  );

constraint
  TotalProfit = sum(k in PARTS) (Profit[k] * Make[k]);

% Objective
solve maximize TotalProfit;