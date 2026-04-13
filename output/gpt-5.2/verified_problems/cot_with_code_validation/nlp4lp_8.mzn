% Parameters
int: NumParts;
int: NumMachines;

set of int: PARTS = 1..NumParts;
set of int: MACHINES = 1..NumMachines;

array[PARTS, MACHINES] of int: Time;
array[PARTS] of int: Profit;
array[MACHINES] of int: Capacity;

% Decision variables: number of units of each part to produce
array[PARTS] of var 0..max(Capacity): x;

% Total profit
var int: TotalProfit = sum(k in PARTS)(Profit[k] * x[k]);

% Machine capacity constraints
constraint
  forall(s in MACHINES) (
    sum(k in PARTS)(Time[k, s] * x[k]) <= Capacity[s]
  );

solve maximize TotalProfit;

output [
  "TotalProfit=", show(TotalProfit), "\n",
  "x=", show(x), "\n"
];