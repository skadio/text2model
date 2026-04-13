int: T = 6;
set of int: Months = 1..T;

array[Months] of int: demand = [430, 430, 380, 450, 520, 440];

int: reg_cap = 420;
int: ot_cap = 80;

int: reg_cost = 40;
int: ot_cost = 45;
int: hold_cost = 3;

int: init_inv = 10;

int: max_total_prod = T * (reg_cap + ot_cap);
int: max_inv = init_inv + max_total_prod;

array[Months] of var 0..reg_cap: reg_prod;
array[Months] of var 0..ot_cap: ot_prod;
array[0..T] of var 0..max_inv: inv;

var 0..(reg_cost * reg_cap * T + ot_cost * ot_cap * T + hold_cost * max_inv * T): total_cost;

constraint inv[0] = init_inv;

constraint forall(m in Months) (
  inv[m] = inv[m - 1] + reg_prod[m] + ot_prod[m] - demand[m]
);

constraint total_cost =
  sum(m in Months)(reg_cost * reg_prod[m] + ot_cost * ot_prod[m] + hold_cost * inv[m]);

solve minimize total_cost;

output ["total_cost=", show(total_cost), "\n"];