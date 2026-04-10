int: P = 3;
int: Q = 4;
set of int: PRODUCTS = 1..P;
set of int: QUARTERS = 1..Q;

array[PRODUCTS, QUARTERS] of int: demand =
  array2d(PRODUCTS, QUARTERS,
    [ 1500, 1000, 2000, 1200,
      1500, 1500, 1200, 1500,
      1000, 2000, 1500, 2500 ]
  );

array[PRODUCTS] of int: hours_per_unit = [2, 4, 3];
int: hours_capacity = 15000;

int: initial_inventory = 0;
int: final_inventory_required = 150;

array[PRODUCTS] of int: delay_cost_per_unit_per_quarter = [20, 20, 10];
int: holding_cost_per_unit_per_quarter = 5;

int: max_units_per_q = hours_capacity div min([hours_per_unit[p] | p in PRODUCTS]);

array[PRODUCTS, QUARTERS] of var 0..max_units_per_q: prod;

array[PRODUCTS] of int: max_total_units =
  [sum(q in QUARTERS)(demand[p,q]) + final_inventory_required | p in PRODUCTS];

array[PRODUCTS, QUARTERS] of var 0..max(max_total_units): ship;
array[PRODUCTS, QUARTERS] of var 0..max(max_total_units): back;
array[PRODUCTS, QUARTERS] of var 0..max(max_total_units): inv;

var 0..1000000000: total_cost;

constraint
  forall(q in QUARTERS)(
    sum(p in PRODUCTS)(hours_per_unit[p] * prod[p,q]) <= hours_capacity
  );

constraint prod[1,2] = 0;

constraint
  forall(p in PRODUCTS, q in QUARTERS)(
    inv[p,q] - back[p,q] =
      (if q = 1 then initial_inventory else inv[p,q-1] endif)
      - (if q = 1 then 0 else back[p,q-1] endif)
      + prod[p,q] - ship[p,q]
  );

constraint
  forall(p in PRODUCTS, q in QUARTERS)(
    back[p,q] =
      (if q = 1 then 0 else back[p,q-1] endif) + demand[p,q] - ship[p,q]
  );

constraint
  forall(p in PRODUCTS, q in QUARTERS)(
    ship[p,q] <= (if q = 1 then demand[p,q] else back[p,q-1] + demand[p,q] endif)
  );

constraint
  forall(p in PRODUCTS)(
    inv[p,Q] >= final_inventory_required
  );

constraint
  forall(p in PRODUCTS)(
    back[p,Q] = 0
  );

constraint
  total_cost =
    sum(p in PRODUCTS, q in QUARTERS)(delay_cost_per_unit_per_quarter[p] * back[p,q]) +
    sum(p in PRODUCTS, q in QUARTERS)(holding_cost_per_unit_per_quarter * inv[p,q]);

solve minimize total_cost;