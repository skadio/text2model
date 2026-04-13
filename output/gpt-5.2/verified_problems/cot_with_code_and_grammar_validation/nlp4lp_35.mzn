% Parameters
int: NumProducts;
int: NumMachines;

set of int: K = 1..NumProducts;
set of int: S = 1..NumMachines;

array[K, S] of int: ProduceTime;
array[S] of int: AvailableTime;
array[K] of int: Profit;

% Variables
int: maxAvail = max(AvailableTime);
int: minPosTime = min([ProduceTime[k,s] | k in K, s in S where ProduceTime[k,s] > 0]);

int: maxUnits = if minPosTime > 0 then maxAvail div minPosTime else 0 endif;

array[K] of var 0..maxUnits: Qty;

% Constraints
constraint
  forall(s in S)(
    sum(k in K)(ProduceTime[k,s] * Qty[k]) <= AvailableTime[s]
  );

% Objective
solve maximize sum(k in K)(Profit[k] * Qty[k]);