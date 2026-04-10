int: Q = 4;
set of int: QUARTERS = 1..Q;

array[QUARTERS] of int: demand = [40, 60, 75, 25];
int: init_inventory = 10;

int: reg_cap = 40;
int: reg_cost = 400;
int: ot_cost = 450;
int: hold_cost = 20;

int: total_demand = sum(q in QUARTERS)(demand[q]);
int: max_total_prod = total_demand;

array[QUARTERS] of var 0..reg_cap: reg_prod;
array[QUARTERS] of var 0..max_total_prod: ot_prod;
array[0..Q] of var 0..(init_inventory + max_total_prod): inv;

var int: total_cost;

constraint inv[0] = init_inventory;

constraint
  forall(q in QUARTERS) (
    inv[q] = inv[q-1] + reg_prod[q] + ot_prod[q] - demand[q]
  );

constraint
  total_cost =
    sum(q in QUARTERS)(reg_cost * reg_prod[q] + ot_cost * ot_prod[q]) +
    sum(q in QUARTERS)(hold_cost * inv[q]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "reg_prod = ", show(reg_prod), "\n",
  "ot_prod = ", show(ot_prod), "\n",
  "inv = ", show(inv), "\n"
];