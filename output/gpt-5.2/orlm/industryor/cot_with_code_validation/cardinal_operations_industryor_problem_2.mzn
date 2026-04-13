% Foldable tables production & HR planning (Jan..Jun) - maximize net profit

%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%
int: T = 6;
set of int: Months = 1..T;

array[Months] of int: demand = [20000, 40000, 42000, 35000, 19000, 18500];

int: init_workforce = 1000;
int: init_inventory = 15000;
int: min_end_inventory = 10000;

int: price = 300;

int: raw_mat_cost = 90;          % per in-house unit
int: outsource_cost = 200;       % per outsourced unit (all-inclusive)

int: hold_cost = 15;             % per unit end inventory
int: backorder_cost = 35;        % per unit end backorder

int: hours_per_unit = 5;

int: reg_hours_per_worker = 160;
int: reg_wage = 30;              % per hour (paid for all regular hours)
int: ot_wage = 40;               % per overtime hour
int: ot_cap_per_worker = 20;     % max overtime hours per worker per month

int: hire_cost = 5000;           % per worker hired
int: fire_cost = 8000;           % per worker fired

% Use 64-bit integers to avoid overflow in objective constants/products
include "globals.mzn";

%%%%%%%%%%%%
% Bounds (safe upper bounds)
%%%%%%%%%%%%
int: inv_ub  = init_inventory + sum(demand) + min_end_inventory;
int: bo_ub   = sum(demand);
int: wf_ub   = init_workforce + sum(demand);  % very loose but safe
int: prod_ub = sum(demand) + min_end_inventory;
int: out_ub  = sum(demand) + min_end_inventory;
int: ot_ub   = wf_ub * ot_cap_per_worker;

%%%%%%%%%%%%
% Variables
%%%%%%%%%%%%
array[Months] of var 0..wf_ub: workforce;
array[Months] of var 0..wf_ub: hire;
array[Months] of var 0..wf_ub: fire;

array[Months] of var 0..prod_ub: prod_inhouse;
array[Months] of var 0..out_ub: prod_outsource;

array[Months] of var 0..ot_ub: overtime_hours;

array[Months] of var 0..inv_ub: inventory_end;
array[Months] of var 0..bo_ub: backorder_end;

var int64: profit;

%%%%%%%%%%%%
% Constraints
%%%%%%%%%%%%

% Workforce balance
constraint workforce[1] = init_workforce + hire[1] - fire[1];
constraint forall(m in 2..T) (
  workforce[m] = workforce[m-1] + hire[m] - fire[m]
);

% Capacity: in-house production uses regular + overtime hours
constraint forall(m in Months) (
  hours_per_unit * prod_inhouse[m]
  <= reg_hours_per_worker * workforce[m] + overtime_hours[m]
);

% Overtime cap
constraint forall(m in Months) (
  overtime_hours[m] <= ot_cap_per_worker * workforce[m]
);

% Inventory/backorder flow:
% (Inv - BO)_end = (Inv - BO)_prev + supply - demand
constraint
  inventory_end[1] - backorder_end[1]
  =
  init_inventory + prod_inhouse[1] + prod_outsource[1] - demand[1];

constraint forall(m in 2..T) (
  inventory_end[m] - backorder_end[m]
  =
  inventory_end[m-1] - backorder_end[m-1]
  + prod_inhouse[m] + prod_outsource[m] - demand[m]
);

% Terminal conditions
constraint inventory_end[T] >= min_end_inventory;
constraint backorder_end[T] = 0;

%%%%%%%%%%%%
% Objective (int64 to prevent overflow)
%%%%%%%%%%%%
constraint profit =
  int64(price) * int64(sum(demand))
  - int64(raw_mat_cost) * int64(sum(m in Months)(prod_inhouse[m]))
  - int64(outsource_cost) * int64(sum(m in Months)(prod_outsource[m]))
  - int64(hold_cost) * int64(sum(m in Months)(inventory_end[m]))
  - int64(backorder_cost) * int64(sum(m in Months)(backorder_end[m]))
  - int64(reg_wage) * int64(reg_hours_per_worker) * int64(sum(m in Months)(workforce[m]))
  - int64(ot_wage) * int64(sum(m in Months)(overtime_hours[m]))
  - int64(hire_cost) * int64(sum(m in Months)(hire[m]))
  - int64(fire_cost) * int64(sum(m in Months)(fire[m]));

solve maximize profit;