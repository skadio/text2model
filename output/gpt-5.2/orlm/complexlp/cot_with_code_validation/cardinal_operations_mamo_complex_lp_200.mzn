include "globals.mzn";

%----------------------------
% Data (embedded)
%----------------------------
int: T = 6;
set of int: Months = 1..T;

array[Months] of int: demand = [430, 430, 380, 450, 520, 440];

int: init_inventory = 10;

int: reg_cap = 420;
int: ot_cap  = 80;

int: reg_cost  = 40;
int: ot_cost   = 45;
int: hold_cost = 3;

% Upper bound for inventory (safe)
int: max_inventory = init_inventory + (reg_cap + ot_cap) * T;

%----------------------------
% Decision variables
%----------------------------
array[Months] of var 0..reg_cap: reg_prod;
array[Months] of var 0..ot_cap:  ot_prod;
array[Months] of var 0..max_inventory: inv;   % end-of-month inventory

% Keep objective as a var with tight-ish bounds
int: max_month_cost = reg_cost*reg_cap + ot_cost*ot_cap + hold_cost*max_inventory;
var 0..T*max_month_cost: total_cost;

%----------------------------
% Constraints
%----------------------------
constraint inv[1] = init_inventory + reg_prod[1] + ot_prod[1] - demand[1];
constraint forall(m in 2..T)(
  inv[m] = inv[m-1] + reg_prod[m] + ot_prod[m] - demand[m]
);

% Total cost: production + holding (holding on end-of-month inventory)
constraint total_cost =
  sum(m in Months)(
    reg_cost * reg_prod[m] + ot_cost * ot_prod[m] + hold_cost * inv[m]
  );

% Symmetry-breaking / search guidance to avoid timeouts
solve :: int_search([reg_prod[m] | m in Months] ++ [ot_prod[m] | m in Months],
                    first_fail, indomain_min, complete)
minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "reg_prod=", show(reg_prod), "\n",
  "ot_prod=", show(ot_prod), "\n",
  "inv=", show(inv), "\n"
];