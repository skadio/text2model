% Parameters (with values embedded)
int: Q = 4;
set of int: QUARTERS = 1..Q;

array[QUARTERS] of int: demand = [40, 60, 75, 25];
int: init_inventory = 10;

int: reg_cap = 40;
int: reg_cost = 400;
int: ot_cost  = 450;
int: hold_cost = 20;

% Variables
array[QUARTERS] of var 0..200: reg_prod;
array[QUARTERS] of var 0..200: ot_prod;
array[0..Q] of var 0..500: inv; % inv[t] = inventory at end of quarter t (inv[0] is initial)

% Constraints
constraint inv[0] = init_inventory;

% Inventory balance and demand satisfaction (must meet demand on time)
constraint forall(t in QUARTERS) (
  inv[t] = inv[t-1] + reg_prod[t] + ot_prod[t] - demand[t]
);

% Regular-time capacity
constraint forall(t in QUARTERS) (
  reg_prod[t] <= reg_cap
);

% Objective
var int: total_cost =
  sum(t in QUARTERS) (
    reg_cost * reg_prod[t] +
    ot_cost  * ot_prod[t] +
    hold_cost * inv[t]
  );

solve minimize total_cost;

output [
  "Minimal total cost = ", show(total_cost), "\n",
  "Quarter | RegProd | OTProd | EndInv\n",
  concat([ show(t) ++ "      | "
           ++ show(reg_prod[t]) ++ "     | "
           ++ show(ot_prod[t]) ++ "    | "
           ++ show(inv[t]) ++ "\n"
         | t in QUARTERS ])
];