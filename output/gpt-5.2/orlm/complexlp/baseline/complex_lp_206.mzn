% Sailco production planning over 4 quarters (LP as MILP with integer units)

int: Q = 4;
set of int: QUARTERS = 1..Q;

array[QUARTERS] of int: demand = [40, 60, 75, 25];
int: init_inventory = 10;

int: reg_cap = 40;
int: cost_reg = 400;
int: cost_ot  = 450;
int: hold_cost = 20;

% Decision variables
array[QUARTERS] of var 0..1000: reg_prod;   % regular-time production
array[QUARTERS] of var 0..1000: ot_prod;    % overtime production
array[0..Q] of var 0..10000: inv;           % end-of-quarter inventory (inv[0] is initial)

constraint inv[0] = init_inventory;

% Inventory balance and capacity
constraint
  forall(t in QUARTERS) (
    reg_prod[t] <= reg_cap /\
    inv[t] = inv[t-1] + reg_prod[t] + ot_prod[t] - demand[t] /\
    inv[t] >= 0
  );

% Objective: production costs + holding costs (incurred at end of each quarter)
var int: total_cost =
  sum(t in QUARTERS)(cost_reg * reg_prod[t] + cost_ot * ot_prod[t] + hold_cost * inv[t]);

solve minimize total_cost;

output [
  "Total minimal cost = ", show(total_cost), "\n",
  "Quarter | RegProd | OTProd | EndInv\n",
  concat([ show(t) ++ "      | " ++ show(reg_prod[t]) ++ "      | " ++ show(ot_prod[t]) ++ "     | " ++ show(inv[t]) ++ "\n"
          | t in QUARTERS ])
];