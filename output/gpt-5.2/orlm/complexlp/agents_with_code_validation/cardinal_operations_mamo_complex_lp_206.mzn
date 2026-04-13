% Sailco production planning (4 quarters) - linear cost minimization

% Parameters (embedded data)
int: Q = 4;
set of int: QUARTERS = 1..Q;

array[QUARTERS] of int: demand = [40, 60, 75, 25];
int: init_inventory = 10;

int: reg_capacity = 40;
int: reg_cost = 400;
int: ot_cost  = 450;
int: hold_cost = 20;

% Safe bounds
int: total_demand = sum(demand);
int: max_inventory = init_inventory + total_demand; % never need more than this
int: max_prod_ot = total_demand;                    % safe per-quarter OT cap

% Decision variables
array[QUARTERS] of var 0..reg_capacity: prod_reg;
array[QUARTERS] of var 0..max_prod_ot: prod_ot;
array[QUARTERS] of var 0..max_inventory: inv_end;

% Inventory balance (demand must be met on time, no backlogging since inv_end >= 0)
constraint inv_end[1] = init_inventory + prod_reg[1] + prod_ot[1] - demand[1];
constraint forall(q in 2..Q)(
  inv_end[q] = inv_end[q-1] + prod_reg[q] + prod_ot[q] - demand[q]
);

% Objective (compute directly to avoid large-domain total_cost variable)
var int: total_cost =
  sum(q in QUARTERS)(
    reg_cost * prod_reg[q] +
    ot_cost  * prod_ot[q] +
    hold_cost * inv_end[q]
  );

solve :: int_search([prod_reg[q] | q in QUARTERS] ++ [prod_ot[q] | q in QUARTERS], first_fail, indomain_min, complete)
minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "prod_reg=", show(prod_reg), "\n",
  "prod_ot=", show(prod_ot), "\n",
  "inv_end=", show(inv_end), "\n"
];