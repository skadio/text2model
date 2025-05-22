% Parameters
int: T;
array[1..T] of int: Deliver;
int: StorageCost;
int: SwitchCost;

% Derived sets and constants
set of int: MONTHS = 1..T;
set of int: MONTHS_EXCEPT_LAST = 1..T-1;
int: TotalDemand = sum(m in MONTHS)(Deliver[m]);

% Variables
array[MONTHS] of var 0..TotalDemand: prod;      % units produced in month m
array[MONTHS] of var int:            inv;       % inventory at end of month m

% Inventory balance
constraint inv[1] = prod[1] - Deliver[1];
constraint forall(m in 2..T)(
    inv[m] = inv[m-1] + prod[m] - Deliver[m]
);

% Non-negativity of inventory
constraint forall(m in MONTHS)(inv[m] >= 0);

% Objective components
var int: totalStorageCost = sum(m in MONTHS_EXCEPT_LAST)(StorageCost * inv[m]);
var int: totalSwitchCost  = sum(m in MONTHS_EXCEPT_LAST)(SwitchCost  * abs(prod[m+1] - prod[m]));
var int: totalCost = totalStorageCost + totalSwitchCost;

solve minimize totalCost;