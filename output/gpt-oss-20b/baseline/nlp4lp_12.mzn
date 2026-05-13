int: T;
array[1..T] of int: Deliver;
int: StorageCost;
int: SwitchCost;

array[0..T] of var int: x;
array[0..T] of var int: inv;

constraint x[0] = 0;
constraint inv[0] = 0;

constraint forall(i in 1..T) (
    inv[i] = inv[i-1] + x[i] - Deliver[i] /\ inv[i] >= 0 /\ x[i] >= 0
);

var int: total_cost = sum(i in 1..T) (
    StorageCost * inv[i] + SwitchCost * abs(x[i] - x[i-1])
);

solve minimize total_cost;

output [
    "Production schedule: ", show(x[1..T]), "\n",
    "Inventory at end of each month: ", show(inv[1..T]), "\n",
    "Total cost: ", show(total_cost), "\n"
];