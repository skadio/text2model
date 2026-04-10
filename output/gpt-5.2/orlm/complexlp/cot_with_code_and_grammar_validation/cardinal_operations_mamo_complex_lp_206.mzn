int: Q = 4;
set of int: QUARTERS = 1..Q;

array[QUARTERS] of int: demand = [40, 60, 75, 25];
int: init_inventory = 10;

int: regular_cap = 40;
int: regular_cost = 400;
int: overtime_cost = 450;
int: holding_cost = 20;

int: total_demand = sum(t in QUARTERS)(demand[t]);
int: max_inventory = init_inventory + total_demand;
array[QUARTERS] of int: ot_ub = [max(0, demand[t] - regular_cap) + max_inventory | t in QUARTERS];

array[QUARTERS] of var 0..regular_cap: reg_prod;
array[QUARTERS] of var 0..max_inventory: ot_prod;

array[0..Q] of var 0..max_inventory: inv;

constraint inv[0] = init_inventory;

constraint forall(t in QUARTERS) (
  inv[t] = inv[t-1] + reg_prod[t] + ot_prod[t] - demand[t]
);

constraint forall(t in QUARTERS) (ot_prod[t] <= ot_ub[t]);

solve minimize
  sum(t in QUARTERS)(regular_cost * reg_prod[t] + overtime_cost * ot_prod[t])
+ sum(t in QUARTERS)(holding_cost * inv[t]);

output [
  "reg_prod = ", show(reg_prod), "\n",
  "ot_prod  = ", show(ot_prod), "\n",
  "inv      = ", show(inv), "\n",
  "total_cost = ", show(
    sum(t in QUARTERS)(regular_cost * reg_prod[t] + overtime_cost * ot_prod[t])
  + sum(t in QUARTERS)(holding_cost * inv[t])
  ), "\n"
];