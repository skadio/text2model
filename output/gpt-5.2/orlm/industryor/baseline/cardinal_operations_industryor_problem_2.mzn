% Foldable tables production/workforce planning (Jan-Jun), maximize net profit
% All data embedded.

int: T = 6;
set of int: M = 1..T;
array[M] of string: month = ["Jan","Feb","Mar","Apr","May","Jun"];

% Initial conditions (start of Jan)
int: init_workers = 1000;
int: init_inventory = 15000;

% Demand forecast
array[M] of int: demand = [20000, 40000, 42000, 35000, 19000, 18500];

% Prices and costs (Yuan)
int: sale_price = 300;
int: raw_mat_cost = 90;          % only in-house units
int: outsource_cost = 200;       % per outsourced finished unit
int: hold_cost = 15;             % per end-of-month inventory unit
int: backorder_cost = 35;        % per end-of-month backorder unit

% Labor and production parameters
int: labor_hours_per_unit = 5;

int: regular_hours_per_worker = 160;     % paid regardless of use
int: regular_wage = 30;                  % per hour
int: overtime_limit_per_worker = 20;     % max OT hours per worker per month
int: overtime_wage = 40;                 % per hour

int: hire_cost = 5000;
int: fire_cost = 8000;

% Terminal conditions (end of June)
int: min_end_inventory = 10000;

% Decision variables
array[M] of var int: workers;      % workforce in month m (nonnegative)
array[M] of var int: hire;         % workers hired at start of month m
array[M] of var int: fire;         % workers fired at start of month m

array[M] of var int: prod;         % in-house production units in month m
array[M] of var int: outsource;    % outsourced units in month m

array[M] of var int: inv;          % end-of-month inventory units
array[M] of var int: bo;           % end-of-month backorder units

array[M] of var int: ot_hours;     % total overtime hours used in month m

% Nonnegativity domains
constraint forall(m in M) (
  workers[m] >= 0 /\ hire[m] >= 0 /\ fire[m] >= 0 /\
  prod[m] >= 0 /\ outsource[m] >= 0 /\
  inv[m] >= 0 /\ bo[m] >= 0 /\ ot_hours[m] >= 0
);

% Workforce balance
constraint workers[1] = init_workers + hire[1] - fire[1];
constraint forall(m in 2..T) (
  workers[m] = workers[m-1] + hire[m] - fire[m]
);

% Overtime capacity and production capacity
constraint forall(m in M) (
  ot_hours[m] <= overtime_limit_per_worker * workers[m]
);

% Production uses labor hours: each unit requires labor_hours_per_unit hours.
% Regular hours available = 160 * workers[m], overtime adds ot_hours[m].
constraint forall(m in M) (
  labor_hours_per_unit * prod[m] <= regular_hours_per_worker * workers[m] + ot_hours[m]
);

% Inventory/Backorder flow with backlogging
% Let starting inventory and backorder:
% inv_0 = init_inventory, bo_0 = 0.
% Define net balance each month:
% inv[m] - bo[m] = (inv[m-1] - bo[m-1]) + prod[m] + outsource[m] - demand[m]
constraint (inv[1] - bo[1] = (init_inventory - 0) + prod[1] + outsource[1] - demand[1]);
constraint forall(m in 2..T) (
  inv[m] - bo[m] = (inv[m-1] - bo[m-1]) + prod[m] + outsource[m] - demand[m]
);

% Terminal conditions
constraint inv[T] >= min_end_inventory;
constraint bo[T] = 0;

% Objective: maximize total net profit
% Revenue: sales_price * total demand (all demand must be met by end, bo[T]=0).
int: total_demand = sum(m in M)(demand[m]);

var int: total_revenue = sale_price * total_demand;

var int: total_cost =
    % In-house variable material cost
    sum(m in M)(raw_mat_cost * prod[m])
  + % Outsourcing
    sum(m in M)(outsource_cost * outsource[m])
  + % Regular wages (paid regardless of utilization)
    sum(m in M)(regular_wage * regular_hours_per_worker * workers[m])
  + % Overtime wages
    sum(m in M)(overtime_wage * ot_hours[m])
  + % Hiring/firing
    sum(m in M)(hire_cost * hire[m] + fire_cost * fire[m])
  + % Holding and backorder costs (end-of-month)
    sum(m in M)(hold_cost * inv[m] + backorder_cost * bo[m]);

var int: profit = total_revenue - total_cost;

solve maximize profit;

output [
  "Profit: ", show(profit), "\n",
  "Total revenue: ", show(total_revenue), "\n",
  "Total cost: ", show(total_cost), "\n\n",
  "Month | Workers | Hire | Fire | Prod(in) | Outsrc | OT_hours | EndInv | EndBO\n",
  "----------------------------------------------------------------------\n"
] ++
[
  month[m], " | ",
  show(workers[m]), " | ",
  show(hire[m]), " | ",
  show(fire[m]), " | ",
  show(prod[m]), " | ",
  show(outsource[m]), " | ",
  show(ot_hours[m]), " | ",
  show(inv[m]), " | ",
  show(bo[m]), "\n"
  | m in M
];