int: T = 6;
set of int: M = 1..T;

array[M] of int: demand = [20000, 40000, 42000, 35000, 19000, 18500];

int: init_workforce = 1000;
int: init_inventory = 15000;

int: price = 300;

int: raw_cost_inhouse = 90;
int: outsource_cost = 200;
int: hold_cost = 15;
int: backorder_cost = 35;

int: labor_hours_per_unit = 5;

int: reg_hours_per_worker = 160;
int: reg_wage_per_hour = 30;

int: ot_max_hours_per_worker = 20;
int: ot_wage_per_hour = 40;

int: hire_cost = 5000;
int: fire_cost = 8000;

int: end_inventory_min = 10000;

int: max_cum_demand = sum(demand);

array[M] of var 0..(init_workforce + max_cum_demand): workforce;
array[M] of var 0..max_cum_demand: hire;
array[M] of var 0..max_cum_demand: fire;

array[M] of var 0..max_cum_demand: prod_inhouse;
array[M] of var 0..max_cum_demand: outsource;

array[M] of var 0..max_cum_demand: inv_end;
array[M] of var 0..max_cum_demand: back_end;

array[M] of var 0..(reg_hours_per_worker * (init_workforce + max_cum_demand)): overtime_hours;

var int: profit;

constraint workforce[1] = init_workforce + hire[1] - fire[1];
constraint forall(m in 2..T) (
  workforce[m] = workforce[m-1] + hire[m] - fire[m]
);

constraint forall(m in M) (
  overtime_hours[m] <= ot_max_hours_per_worker * workforce[m]
);

constraint forall(m in M) (
  labor_hours_per_unit * prod_inhouse[m]
  <= reg_hours_per_worker * workforce[m] + overtime_hours[m]
);

constraint inv_end[1] - back_end[1]
  = init_inventory + prod_inhouse[1] + outsource[1] - demand[1];

constraint forall(m in 2..T) (
  inv_end[m] - back_end[m]
  = (inv_end[m-1] - back_end[m-1]) + prod_inhouse[m] + outsource[m] - demand[m]
);

constraint inv_end[T] >= end_inventory_min;
constraint back_end[T] = 0;

constraint profit =
  price * sum(m in M)(demand[m])
  - raw_cost_inhouse * sum(m in M)(prod_inhouse[m])
  - outsource_cost * sum(m in M)(outsource[m])
  - hold_cost * sum(m in M)(inv_end[m])
  - backorder_cost * sum(m in M)(back_end[m])
  - reg_wage_per_hour * reg_hours_per_worker * sum(m in M)(workforce[m])
  - ot_wage_per_hour * sum(m in M)(overtime_hours[m])
  - hire_cost * sum(m in M)(hire[m])
  - fire_cost * sum(m in M)(fire[m]);

solve maximize profit;