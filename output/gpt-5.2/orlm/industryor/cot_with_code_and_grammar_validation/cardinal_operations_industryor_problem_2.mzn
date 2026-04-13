include "globals.mzn";

int: T = 6;
set of int: M = 1..T;

array[M] of int: demand = [20000, 40000, 42000, 35000, 19000, 18500];

int: init_workforce = 1000;
int: init_inventory = 15000;

int: end_min_inventory = 10000;

int: price = 300;
int: raw_mat_cost = 90;
int: outsource_cost = 200;

int: hold_cost = 15;
int: backorder_cost = 35;

int: hours_per_unit = 5;

int: reg_hours_per_worker = 160;
int: reg_wage = 30;
int: ot_max_per_worker = 20;
int: ot_wage = 40;

int: hire_cost = 5000;
int: fire_cost = 8000;

int: total_demand = sum(demand);
int: inv_ub = init_inventory + total_demand;
int: bo_ub  = total_demand;
int: wf_ub  = init_workforce + total_demand;

array[M] of var 0..wf_ub: workforce;
array[M] of var 0..wf_ub: hire;
array[M] of var 0..wf_ub: fire;

array[M] of var 0..inv_ub: inv;
array[M] of var 0..bo_ub: back;

array[M] of var 0..inv_ub: inhouse;
array[M] of var 0..inv_ub: outsource;

array[M] of var 0..(wf_ub * ot_max_per_worker): ot_hours;

constraint workforce[1] = init_workforce + hire[1] - fire[1];
constraint forall(m in 2..T)(
  workforce[m] = workforce[m-1] + hire[m] - fire[m]
);

constraint forall(m in M)(
  hours_per_unit * inhouse[m] <= reg_hours_per_worker * workforce[m] + ot_hours[m]
);

constraint forall(m in M)(
  ot_hours[m] <= ot_max_per_worker * workforce[m]
);

constraint inv[1] - back[1] =
  init_inventory + inhouse[1] + outsource[1] - demand[1];

constraint forall(m in 2..T)(
  inv[m] - back[m] =
    (inv[m-1] - back[m-1]) + inhouse[m] + outsource[m] - demand[m]
);

constraint inv[T] >= end_min_inventory;
constraint back[T] = 0;

var int: total_profit =
    sum(m in M)( price * demand[m] )
  - sum(m in M)( raw_mat_cost * inhouse[m] )
  - sum(m in M)( outsource_cost * outsource[m] )
  - sum(m in M)( hold_cost * inv[m] )
  - sum(m in M)( backorder_cost * back[m] )
  - sum(m in M)( reg_wage * reg_hours_per_worker * workforce[m] )
  - sum(m in M)( ot_wage * ot_hours[m] )
  - sum(m in M)( hire_cost * hire[m] + fire_cost * fire[m] );

solve maximize total_profit;

output [
  "Total profit: ", show(total_profit), "\n",
  "Month\tWF\tHire\tFire\tInHouse\tOutsrc\tOT_hrs\tInv\tBack\n"
] ++
[
  show(m) ++ "\t" ++ show(workforce[m]) ++ "\t" ++ show(hire[m]) ++ "\t" ++ show(fire[m]) ++ "\t"
  ++ show(inhouse[m]) ++ "\t" ++ show(outsource[m]) ++ "\t" ++ show(ot_hours[m]) ++ "\t"
  ++ show(inv[m]) ++ "\t" ++ show(back[m]) ++ "\n"
  | m in M
];