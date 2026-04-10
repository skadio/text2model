% Sailco production planning (LP as MILP with integer units)

% Parameters
int: T = 4;
set of int: Q = 1..T;

array[Q] of int: demand = [40, 60, 75, 25];
int: init_inventory = 10;

int: reg_cap   = 40;
int: reg_cost  = 400;
int: ot_cost   = 450;
int: hold_cost = 20;

int: total_demand = sum(q in Q)(demand[q]);
int: max_prod_per_q = total_demand;          % safe upper bound for overtime per quarter
int: max_inventory  = init_inventory + total_demand;

% Decision variables
array[Q] of var 0..reg_cap: reg_prod;
array[Q] of var 0..max_prod_per_q: ot_prod;
array[0..T] of var 0..max_inventory: inv;    % inventory at end of each quarter, with inv[0] initial

% Inventory balance
constraint inv[0] = init_inventory;
constraint forall(q in Q)(
  inv[q] = inv[q-1] + reg_prod[q] + ot_prod[q] - demand[q]
);

% Objective
var int: total_cost =
  sum(q in Q)(
    reg_cost * reg_prod[q] +
    ot_cost  * ot_prod[q] +
    hold_cost * inv[q]
  );

solve :: int_search([reg_prod[q] | q in Q] ++ [ot_prod[q] | q in Q] ++ [inv[q] | q in 0..T],
                    input_order, indomain_min, complete)
minimize total_cost;

output [
  "Total cost = ", show(total_cost), "\n",
  "reg_prod   = ", show([reg_prod[q] | q in Q]), "\n",
  "ot_prod    = ", show([ot_prod[q] | q in Q]), "\n",
  "inv_end    = ", show([inv[q] | q in Q]), "\n"
];