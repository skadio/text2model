int: NumProducts;
int: NumMachines;

array[1..NumProducts, 1..NumMachines] of int: ProduceTime;
array[1..NumMachines]                   of int: AvailableTime;
array[1..NumProducts]                   of int: Profit;

% Helper
function int: safe_div(int: a, int: b) = if b > 0 then a div b else 0 endif;

% Maximum feasible production for each product (upper bound)
array[p in 1..NumProducts] of int: MaxProd =
  [ min([ safe_div(AvailableTime[s], ProduceTime[p,s])
          | s in 1..NumMachines where ProduceTime[p,s] > 0 ])
  | p in 1..NumProducts ];

% Decision variables
array[p in 1..NumProducts] of var 0..MaxProd[p]: Qty;

% Objective
var int: TotalProfit = sum(p in 1..NumProducts)(Profit[p] * Qty[p]);

% Capacity constraints
constraint
  forall(s in 1..NumMachines)(
    sum(p in 1..NumProducts)(ProduceTime[p,s] * Qty[p]) <= AvailableTime[s]
  );

solve maximize TotalProfit;