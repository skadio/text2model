% Basel Tool and Die (BTD) aggregate production planning (6 months)
% Minimize total cost = regular production + overtime production + inventory holding

int: T = 6;
set of int: Months = 1..T;

array[Months] of int: demand = [430, 430, 380, 450, 520, 440];

int: init_inv = 10;

int: reg_cap = 420;
int: ot_cap  = 80;

int: reg_cost = 40;
int: ot_cost  = 45;
int: hold_cost = 3;

array[Months] of var 0..reg_cap: reg_prod;
array[Months] of var 0..ot_cap: ot_prod;

% Inventory at end of each month
% Upper bound: enough to cover remaining demand (safe bound)
int: total_demand = sum(i in Months)(demand[i]);
array[Months] of var 0..total_demand: inv;

constraint
  forall(t in Months)(
    inv[t] =
      (if t = 1 then init_inv else inv[t-1] endif)
      + reg_prod[t] + ot_prod[t]
      - demand[t]
  );

% Must satisfy demand each month (no backlogging): inventory cannot go negative already ensured by domain

var int: total_cost =
  sum(t in Months)(reg_cost * reg_prod[t] + ot_cost * ot_prod[t] + hold_cost * inv[t]);

solve minimize total_cost;

output [
  "Minimal total cost (USD): ", show(total_cost), "\n"
];