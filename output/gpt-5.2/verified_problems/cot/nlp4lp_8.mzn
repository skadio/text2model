% Parameters
int: NumParts;
int: NumMachines;

set of int: PARTS = 1..NumParts;
set of int: MACHINES = 1..NumMachines;

array[PARTS, MACHINES] of int: Time;
array[PARTS] of int: Profit;
array[MACHINES] of int: Capacity;

% Variables
int: maxProfitPerUnit = sum(k in PARTS)(max(0, Profit[k]));
int: maxUnitsBound =
  if maxProfitPerUnit > 0 then
    sum(s in MACHINES)(Capacity[s]) div max(1, min(k in PARTS, ss in MACHINES where Time[k,ss] > 0)(Time[k,ss]))
  else 0 endif;

array[PARTS] of var 0..max(0, maxUnitsBound): Produce;

var int: TotalProfit;

% Constraints
constraint
  forall(s in MACHINES)(
    sum(k in PARTS)(Time[k,s] * Produce[k]) <= Capacity[s]
  );

constraint
  TotalProfit = sum(k in PARTS)(Profit[k] * Produce[k]);

% Objective
solve maximize TotalProfit;