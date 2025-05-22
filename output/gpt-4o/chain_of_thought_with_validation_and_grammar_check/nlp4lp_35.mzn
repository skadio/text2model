% Parameters
int: NumProducts;
int: NumMachines;

array[1..NumProducts, 1..NumMachines] of int: ProduceTime;
array[1..NumMachines] of int: AvailableTime;
array[1..NumProducts] of int: Profit;

% Derived constants
array[1..NumProducts] of int: MaxProd =
  [ min([AvailableTime[s] div ProduceTime[k, s] | s in 1..NumMachines])
    | k in 1..NumProducts ];

int: MaxUpper = max(MaxProd);

% Variables
array[1..NumProducts] of var 0..MaxUpper: Qty;

% Constraints
constraint
  forall(k in 1..NumProducts)(
    Qty[k] <= MaxProd[k]
  );

constraint
  forall(s in 1..NumMachines)(
    sum(k in 1..NumProducts)(ProduceTime[k, s] * Qty[k]) <= AvailableTime[s]
  );

% Objective
solve maximize sum(k in 1..NumProducts)(Profit[k] * Qty[k]);