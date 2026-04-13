% Parameters (with values embedded)
int: T = 6;
set of int: Months = 1..T;

array[Months] of int: demand = [20000, 40000, 42000, 35000, 19000, 18500];

int: init_workforce = 1000;
int: init_inventory = 15000;

int: price = 300;

int: raw_mat_cost = 90;          % per in-house unit
int: outsource_cost = 200;       % per outsourced unit

int: hold_cost = 15;             % per unit ending inventory
int: backorder_cost = 35;        % per unit ending backorder

int: labor_hours_per_unit = 5;

int: reg_hours_per_worker = 160;
int: reg_wage_per_hour = 30;     % paid for all regular hours regardless of utilization
int: ot_max_hours_per_worker = 20;
int: ot_wage_per_hour = 40;

int: hire_cost = 5000;
int: fire_cost = 8000;

int: min_end_inventory = 10000;

% Big-M style bounds (safe upper bounds)
int: max_workforce = 20000;                 % conservative upper bound
int: max_prod = 200000;                     % conservative monthly upper bound
int: max_outsource = 200000;                % conservative monthly upper bound
int: max_inventory = 300000;                % conservative upper bound
int: max_backorder = 300000;                % conservative upper bound
int: max_ot_hours = max_workforce * ot_max_hours_per_worker;

% Variables
array[Months] of var 0..max_workforce: workforce;      % workforce available during month
array[Months] of var 0..max_workforce: hire;
array[Months] of var 0..max_workforce: fire;

array[Months] of var 0..max_prod: prod_inhouse;
array[Months] of var 0..max_outsource: outsource;

array[Months] of var 0..max_ot_hours: overtime_hours;

array[0..T] of var 0..max_inventory: inventory;        % end-of-month inventory, inventory[0] initial
array[0..T] of var 0..max_backorder: backorder;        % end-of-month backorder, backorder[0] initial

% Constraints
constraint inventory[0] = init_inventory;
constraint backorder[0] = 0;

% Workforce flow
constraint workforce[1] = init_workforce + hire[1] - fire[1];
constraint forall(m in 2..T)(
  workforce[m] = workforce[m-1] + hire[m] - fire[m]
);

% Production capacity via regular + overtime labor
% Regular hours are available up to 160 per worker (paid regardless); overtime is a decision, limited to 20 per worker.
constraint forall(m in Months)(
  labor_hours_per_unit * prod_inhouse[m]
    <= reg_hours_per_worker * workforce[m] + overtime_hours[m]
);
constraint forall(m in Months)(
  overtime_hours[m] <= ot_max_hours_per_worker * workforce[m]
);

% Inventory / backorder balance with backlogging:
% inventory[m] - backorder[m] = inventory[m-1] - backorder[m-1] + supply - demand
constraint forall(m in Months)(
  inventory[m] - backorder[m]
    = inventory[m-1] - backorder[m-1] + prod_inhouse[m] + outsource[m] - demand[m]
);

% Terminal conditions (end of June)
constraint inventory[T] >= min_end_inventory;
constraint backorder[T] = 0;

% Objective
% Revenue assumes all demand is eventually satisfied; with end backorder = 0, total units sold over horizon = sum(demand).
% Net profit = revenue - (raw material + outsourcing + wages + overtime + holding + backorder + hiring/firing)
var int: total_revenue = price * sum(m in Months)(demand[m]);

var int: total_raw = raw_mat_cost * sum(m in Months)(prod_inhouse[m]);
var int: total_out = outsource_cost * sum(m in Months)(outsource[m]);

% Regular wages: paid for 160 hours per worker per month
var int: total_reg_wages = reg_wage_per_hour * reg_hours_per_worker * sum(m in Months)(workforce[m]);

var int: total_ot_wages = ot_wage_per_hour * sum(m in Months)(overtime_hours[m]);

var int: total_hold = hold_cost * sum(m in Months)(inventory[m]);
var int: total_back = backorder_cost * sum(m in Months)(backorder[m]);

var int: total_hire = hire_cost * sum(m in Months)(hire[m]);
var int: total_fire = fire_cost * sum(m in Months)(fire[m]);

var int: net_profit =
  total_revenue
  - total_raw - total_out
  - total_reg_wages - total_ot_wages
  - total_hold - total_back
  - total_hire - total_fire;

solve maximize net_profit;