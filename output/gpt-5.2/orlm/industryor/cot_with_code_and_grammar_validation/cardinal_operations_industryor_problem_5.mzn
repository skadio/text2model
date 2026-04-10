int: P = 3;
int: Q = 4;

set of int: PRODUCTS = 1..P;
set of int: QUARTERS = 1..Q;

array[PRODUCTS, QUARTERS] of int: demand =
  [| 1500, 1000, 2000, 1200
   | 1500, 1500, 1200, 1500
   | 1000, 2000, 1500, 2500
  |];

array[PRODUCTS] of int: hours_per_unit = [2, 4, 3];
int: hours_capacity = 15000;

int: init_inventory = 0;
int: end_inventory_req = 150;

array[PRODUCTS] of int: late_penalty = [20, 20, 10];
int: holding_cost = 5;

int: forbidden_p = 1;
int: forbidden_q = 2;

array[PRODUCTS] of int: total_demand =
  [sum(q in QUARTERS)(demand[p, q]) | p in PRODUCTS];

array[PRODUCTS] of int: max_prod_p =
  [total_demand[p] + end_inventory_req | p in PRODUCTS];

int: MAX_PROD = max(p in PRODUCTS)(max_prod_p[p]);
int: MAX_INV  = max(p in PRODUCTS)(total_demand[p] + end_inventory_req);
int: MAX_BACK = max(p in PRODUCTS)(total_demand[p]);

array[PRODUCTS, QUARTERS] of var 0..MAX_PROD: prod;
array[PRODUCTS, QUARTERS] of var 0..MAX_INV: inv;
array[PRODUCTS, QUARTERS] of var 0..MAX_BACK: back;

constraint
  forall(q in QUARTERS)(
    sum(p in PRODUCTS)(hours_per_unit[p] * prod[p, q]) <= hours_capacity
  );

constraint
  forall(p in PRODUCTS)(
    inv[p, 1] - back[p, 1] = init_inventory + prod[p, 1] - demand[p, 1]
  );

constraint
  forall(p in PRODUCTS, q in 2..Q)(
    inv[p, q] - back[p, q] =
      (inv[p, q-1] - back[p, q-1]) + prod[p, q] - demand[p, q]
  );

constraint
  forall(p in PRODUCTS)(
    inv[p, Q] >= end_inventory_req
  );

constraint prod[forbidden_p, forbidden_q] = 0;

var int: total_cost =
    holding_cost * sum(p in PRODUCTS, q in QUARTERS)(inv[p, q])
  + sum(p in PRODUCTS, q in QUARTERS)(late_penalty[p] * back[p, q]);

solve minimize total_cost;

output
[
  "Total cost = ", show(total_cost), "\n",
  "Production (p x q):\n",
  concat([ concat([ show(prod[p, q]) ++ (if q == Q then "\n" else "\t" endif)
                  | q in QUARTERS ])
         | p in PRODUCTS ]),
  "Inventory (end of q):\n",
  concat([ concat([ show(inv[p, q]) ++ (if q == Q then "\n" else "\t" endif)
                  | q in QUARTERS ])
         | p in PRODUCTS ]),
  "Backlog (end of q):\n",
  concat([ concat([ show(back[p, q]) ++ (if q == Q then "\n" else "\t" endif)
                  | q in QUARTERS ])
         | p in PRODUCTS ])
];